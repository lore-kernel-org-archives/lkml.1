Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYLVHs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYLVHs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 02:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYLVHsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 02:48:47 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:61218 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYLVHsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 02:48:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LkMowv7k1k53pwGk8CoIv0nrOrKUIHot/i2jzzkmsAS/WfsW5tX6jvvvlyUAyEbRdI
         9aVEnf736hb6gYy4fsfDyXradJlnil6ULxd8PH5ZvFxbSeFY2ZGFNfO4NwIDvHD6IAOx
         +5nl7RJI/Y+V2Uj5I946bDBL81rdo/7T6y64M=
Message-ID: <494F4656.6010109@panasas.com>
Date: Mon, 22 Dec 2008 09:48:38 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jaswinder Singh <jaswinderlinux@gmail.com>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Firmware patches for SCSI
References: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>	<1229718543.18778.4.camel@localhost.localdomain>	<3f9a31f40812191241q40dafdb0lfd2f4487f2870e2@mail.gmail.com>	<1229720031.18778.8.camel@localhost.localdomain> <20081222171904.b588da94.sfr@canb.auug.org.au>
In-Reply-To: <20081222171904.b588da94.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi James,
> 
> On Fri, 19 Dec 2008 15:53:51 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>> OK, then whatever tree contains them needs to eject them or be dropped
>> from linux-next.
> 
> That is a problem for me and David.  Do not let it concern you ... :-)
> 
>>> So I am curious that should I resend these patches based on which git tree.
>> Yes please.  For me it would be against scsi-misc ... for the other
>> drivers it would be their development tree.  The simplest thing to do is
>> probably to rebase them all on top of linux-next (which contains all of
>> our trees) and then send them to the individual subsystem maintainer
>> lists.
> 
> Please don't do that, please base each one on either Linus' tree or the
> appropriate maintainer's subsystem tree as linux-next is a moving
> target (for instance, if you had based the scsi ones on next-20081219,
> then the scsi tree was not included ...).  Basing on Linus' tree should
> work in most cases as there are not to many conflicts caused by these
> patches (the tg3 one is the worst so basing that off the net tree is
> probably worth while).
> 

I think what James meant is to rebase over linux-next when cutting the
patches in order to send them to the different maintainers over email.
In that case linux-next is perfect because you are sure none of the
patches will conflict with any maintainer and you do that all in one
place. Since you are not merging then linux-next volatility does not
matter.

My $0.017
Boaz
