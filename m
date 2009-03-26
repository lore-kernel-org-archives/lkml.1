Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZCZKyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZCZKyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 06:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZCZKy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 06:54:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:30908 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZCZKy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 06:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Wkc30jQhYhn+/u/R9YnRD5nNSrcIZnPezvetrfhskhiwVdFNs/A/Lq+6J46iosgv5T
         bTddwU1ds/1wlNM7+QmXsTrM5js/cuIbgmJBrCQOPwTdsQgTvDAXHsCjucM+pDla6beg
         tUWxxlf5jw5iIoYWfH3Ec9Rb2PykpYfH7skPE=
MIME-Version: 1.0
Date: Thu, 26 Mar 2009 19:54:25 +0900
Message-ID: <49b7c2350903260354p6eaf50ebo87985dcfb8d48ba0@mail.gmail.com>
Subject: Re: [Announce] 2.6.29-rt1
From: GeunSik Lim <leemgs1@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I understood statement that Thosmas explained about invalid access of
2.6.29-rt1 soruces.
In general,
We remeber rc directory (./v2.6/testing/ and release directory
(./v2.6/) certainly.

Release Version is located in http://www.kernel.org/pub/linux/kernel/v2.6/ site.
RC      Version is located in
http://www.kernel.org/pub/linux/kernel/v2.6/testing/ site.

I summarized quick howto per notice of "2.6.* rt patch" file.
fc9#> wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.tar.bz2
  (If linux version is RC[release candidate] version,
 use "wget http://www.kernel.org/pub/linux/kernel/v2.6/testing/***" command.)
fc9#> wget http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rt1.bz2
fc9#> tar xjf ./linux-2.6.29.tar.bz2
fc9#> tar xvjf ./patch-2.6.29-rt1-broken-out.tar.bz2
fc9#> cd ./linux-2.6.29
fc9#> for i in `cat ../patches/series | grep patch | grep -v "#"  `;do
echo "+++ patching $i"; patch -p1 <

../patches/$i;done
fc9#> cp ./arch/x86/configs/i386_defconfig ./.config
fc9#> make menuconfig
        ..... Below Omission .....
  	

Regards,
GeunSik Lim

----- Original Message -----
From: "Thomas Gleixner" <tglx@linutronix.de>
To: "Jaswinder Singh Rajput" <jaswinder@kernel.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>; "rt-users"
<linux-rt-users@vger.kernel.org>; "Ingo Molnar" <mingo@elte.hu>;
"Steven Rostedt" <rostedt@goodmis.org>; "Peter Zijlstra"
<peterz@infradead.org>; "Carsten Emde" <ce@ceag.ch>; "Clark Williams"
<williams@redhat.com>; "Frank Rowand" <frank.rowand@am.sony.com>
Sent: Thursday, March 26, 2009 6:09 AM
Subject: Re: [Announce] 2.6.29-rt1


> On Thu, 26 Mar 2009, Jaswinder Singh Rajput wrote:
>
>> On Wed, 2009-03-25 at 21:59 +0100, Thomas Gleixner wrote:
>> > We are pleased to announce the next update to our new preempt-rt
>> > series.
>> >
>> >      - port forward to 2.6.29 final
>> >
>> > Download locations:
>> >
>> >     http://rt.et.redhat.com/download/
>> >     http://www.kernel.org/pub/linux/kernel/projects/rt/
>> >
>> > Information on the RT patch can be found at:
>> >
>> >     http://rt.wiki.kernel.org/index.php/Main_Page
>> >
>> > to build the 2.6.29-rt1 tree, the following patches should be
>> > applied:
>> >
>> >     http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29.tar.bz2
>>
>> Is this valid ?
>
> If we remove the testing/ it should work better :)
>
>   tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>
