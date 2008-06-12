Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYFLCK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYFLCK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 22:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYFLCKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 22:10:13 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:24337 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYFLCKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 22:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tOurd+fz2u4WIZDG6BmGQRmd7jkatMyo1JWXNYU30JvN5UHtrPSjutYdyekN0heOKL
         XjlVpBq/aiMdrGN9js+IpBgQK1o6NsWfDhP6h8f7O37f7wZLeIwRwHjlhkqltq4MFVrG
         mJcWUEJwLAmMwPRejQArpV2ziSV5Med5LCtlw=
Message-ID: <dd18b0c30806111910j4b127c32rbd546f885731e18c@mail.gmail.com>
Date: Thu, 12 Jun 2008 02:10:10 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <4850794F.3000200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>
	 <20080404012147.abf8a598.akpm@linux-foundation.org>
	 <484F31B8.8030001@gmail.com>
	 <dd18b0c30806110045s6d19a034yd89b892441bd1621@mail.gmail.com>
	 <dd18b0c30806111131gc1b506cva12f577ebb4afdf9@mail.gmail.com>
	 <485048EC.2080608@gmail.com>
	 <dd18b0c30806111527x22fa895em230ceade4712f073@mail.gmail.com>
	 <4850794F.3000200@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 1:18 AM, Tejun Heo <htejun@gmail.com> wrote:
> Justin Mattock wrote:
>> O.K. attached is dmesg of playing a dvd, then suspending and wakingup,
>> as well as starting after the buffer error.(audit messages)
>> This is interesting, even  pausing the dvd before suspending, causes
>> the same error.
>> I sent a post to mplayer-users to see if there is a way to have
>> mplayer pause and wait for the disk drive to align, but am still
>> waiting
>> for a response.
>
> Can you please do the followings?
>
> 1. dd if=/dev/sr0 of=/dev/null bs=1M
> 2. suspend / resume
> 3. see whether dd fails and post the resulting dmesg.
>
> Thanks.
>
> --
> tejun
>

Hello; I did what you had suggested(twice below is the first,same
results with second)
 upon wakeup dd just quits giving me this:

dd: reading `/dev/sr0': Input/output error
3+1 records in
3+1 records out
3276800 bytes (3.3 MB) copied, 21.834 seconds, 150 kB/s

And under dmesg:
[  329.596421] end_request: I/O error, dev sr0, sector 6400
[  329.596437] Buffer I/O error on device sr0, logical block 800
[  329.596903] Buffer I/O error on device sr0, logical block 833
[  329.596912] Buffer I/O error on device sr0, logical block 834
[  329.596919] Buffer I/O error on device sr0, logical block 835
[  329.596926] Buffer I/O error on device sr0, logical block 836
[  329.596934] Buffer I/O error on device sr0, logical block 837
[  329.596941] Buffer I/O error on device sr0, logical block 838
[  329.596949] Buffer I/O error on device sr0, logical block 839
[  329.596956] Buffer I/O error on device sr0, logical block 840
[  329.596963] Buffer I/O error on device sr0, logical block 841

regards;


-- 
Justin P. Mattock
