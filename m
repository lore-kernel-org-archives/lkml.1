Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZEZC1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZEZC1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 22:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZEZC06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 22:26:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:43434 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZEZC05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 22:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=titQ2ZmzMgWH3JmChWb6teNWEf5VRBdjRXN55SCHGzQUY/VheBg8qxQ9uiGCcSStaH
         mKA5PRy5aL3qnb79TgZHbWS+hi6kIeDUEg0Bqv78lcigayxw1Xc6kUTzdsDkVYTYtfAP
         AuWaqdkim7LZB7BOrTD7ORNZVSy2g09kexkWc=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905251605k5491f271q6432ccaef3e653fd@mail.gmail.com>
References: <20090525205353.GB6856@redhat.com>
	 <Pine.LNX.4.44L0.0905251704490.27717-100000@netrider.rowland.org>
	 <20090525214755.GE6856@redhat.com> <20090525223120.GC11648@ub>
	 <ac3eb2510905251605k5491f271q6432ccaef3e653fd@mail.gmail.com>
Date: Tue, 26 May 2009 10:26:58 +0800
Message-ID: <d82e647a0905251926yc165bfcteb4e78ab1d0162c6@mail.gmail.com>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
From: Ming Lei <tom.leiming@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/26 Kay Sievers <kay.sievers@vrfy.org>:
> On Tue, May 26, 2009 at 00:31, Andries E. Brouwer
> <Andries.Brouwer@cwi.nl> wrote:
>
>> I can imagine that your device is a slow starter and needs some time
>> to initialize itself, so that the first, or the first few, commands fail,
>> and after that all is well.
>
> Michael, what's the value of:
>  /sys/module/usb_storage/parameters/delay_use
> ?

>From the usbmon trace, we can find that delay_use should be 5sec, so
nothing to do with it.

ef6c5e80 3223722144 S Ci:1:006:0 s 80 06 0303 0409 00ff 255 <
ef6c5e80 3223722262 C Ci:1:006:0 0 30 = 1e033000 30003000 30003000
30003100 20002000 20002000 20002000 2000
ef6c5e80 3223722408 S Co:1:006:0 s 00 09 0001 0000 0000 0
ef6c5e80 3223722513 C Co:1:006:0 0 0
------------------------------delay
5sec----------------------------------------------------
ef48ab00 3228749167 S Ci:1:006:0 s a1 fe 0000 0000 0001 1 <
ef48ab00 3228749297 C Ci:1:006:0 0 1 = 00


-- 
Lei Ming
