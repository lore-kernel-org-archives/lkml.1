Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab0BXVyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:54:13 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62435 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab0BXVyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JKF1+bWB40s0N3cJPzI8DGL+SAeFLm6PYw0/0kQp9W5TFZso3xL42gGNviXswe4H5P
         /nH8RleJuIpqoWAdtqrCSQ0p35F9KUtBUf2F9xI6xlY9SkA8y67fmLM1tXfpTS908QiJ
         iPF1hbux8EvluJpWu5XXzbW6pamAUCk/GXFuk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002241849490.4245@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
	 <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
	 <520f0cf11002220311l2a0caa83lf3ae2817b78501b6@mail.gmail.com>
	 <49b7c2351002231708r279049f9hcc9cc6ff205a47fb@mail.gmail.com>
	 <25891f3e1002231719u4d38ed52w99c66ac669c3d965@mail.gmail.com>
	 <49b7c2351002240643s1aebe384wee5ee7951e62640e@mail.gmail.com>
	 <alpine.LFD.2.00.1002241609050.4245@localhost.localdomain>
	 <49b7c2351002240852u3b2e7a56g1b0140d37a02c81f@mail.gmail.com>
	 <alpine.LFD.2.00.1002241849490.4245@localhost.localdomain>
Date: Thu, 25 Feb 2010 06:54:10 +0900
Message-ID: <49b7c2351002241354n32a614d4hc4d85f2d378b9b24@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt1
From: GeunSik Lim <leemgs1@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dhaval Giani <dhaval.lists@thegianis.in>, John Kacur <jkacur@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 2:52 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 25 Feb 2010, GeunSik Lim wrote:
>> On Thu, Feb 25, 2010 at 12:09 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >> So, I tried linux-2.6.33-rc8-rt1 based on tip/rt/head as you explained.
>> >>
>> >> Git development branch:
>> >>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head
>> > What's the sha1 of the head commit ?
>> > Thanks,
>> >        tglx
>> >
>> Dear Thoomas,
>>
>> Below was the  recent commit number  when I typed "git clone" command.
>>
>> commit ed0799048b4a38ffb6e33755ba5e6b5dfa9a24d2
>> Author: Thomas Gleixner <tglx@linutronix.de>
>> Date:   Sun Feb 21 23:14:28 2010 +0100
>>
>>     v2.6.33-rt1
>
> So you cloned the rt/2.6.33 branch of tip. rt/head does not have
> release numbers. The version in the Makefile is simply
> 2.6.33-rc8-rt. rt/head is where development happens. When stuff seems
> stable I update rt/2.6.xx and bump the -rt version and tag it.
Thank you for explanation of the rt/*** branch meaning. :)
Currently, I am using the rt/2.6.33 branch
with "git checkout -b  v2.6.33-rc8-rt2 v2.6.33-rc8-rt2" command.

[invain@localhost 2.6.33]$ git branch
  master
  v2.6.33-rc8-rt1
* v2.6.33-rc8-rt2
[invain@localhost 2.6.33]$ pwd
/opt/rt/2.6.33

As I reported finally now is normal with -rc8-rt2.
*  Booting result of linux-2.6.33-rc8-rt2 on Q9400 PC. --> Passed.
http://picasaweb.google.com/leemgs/LinuxRelatedScreenshot#5441865625183643634
>
> Thanks,
>
>        tglx



-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
