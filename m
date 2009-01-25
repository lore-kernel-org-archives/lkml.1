Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZAYVtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZAYVtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 16:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZAYVs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 16:48:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:19350 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZAYVs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 16:48:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=c/D3IzkGTT/aHd9roAi3ULVXwpfMwidHzqxyfea52F+XWsHY/Nen2B/RnHL9uqTf6K
         HPpFhTknu1rjUb3Pr5o5PJh6805gWbJDptBI3q/kg2VNuUFjlmsCKRS+kZqp9esgfVmx
         JtT9VNhERSY+7/qN6iZWO5HhDN97sCISEqi0o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: hdb: status error: error=0x40 <3>{ UncorrectableError }
Date: Sun, 25 Jan 2009 22:49:16 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090123; KDE/4.1.3; i686; ; )
Cc: Bill Davidsen <davidsen@tmr.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com> <497CD30D.80203@tmr.com> <3f9a31f40901251310g38ecfe61t97e119533215d271@mail.gmail.com>
In-Reply-To: <3f9a31f40901251310g38ecfe61t97e119533215d271@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901252249.17410.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 January 2009, Jaswinder Singh Rajput wrote:
> On Mon, Jan 26, 2009 at 2:31 AM, Bill Davidsen <davidsen@tmr.com> wrote:
> >
> >
> > Alan Cox wrote:
> >>
> >> On Mon, 26 Jan 2009 02:09:56 +0530
> >> Jaswinder Singh Rajput
> >> <jaswinderlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> Hello all,
> >>>
> >>> I added extra IDE drive I get similar messages like below so I replace
> >>> it another drive but I am still getting similar error messages on
> >>> 2.6.29-rc2-tip:
> >>>
> >>> hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest
> >>> Error }
> >>> hdb: status error: error=0x40 <3>{ UncorrectableError },
> >>> LBAsect=208845, sector=0
> >>
> >> Uncorrectable Error is an error from the drive, not the kernel. Looks
> >> like you have bad sectors on that drive.
> >>
> > He noted that he tried another drive, so unless he has a pile of bad drives
> > it's probably something else. Being "hdb" may indicate that it's connected
> > to the same controller as "hda" and might not be jumpered for slave. Or it
> > might be a bad cable, a controller which doesn't like two drives, a dubious
> > power connector, etc. Or if he doesn't have an hda, perhaps the kernel
> > doesn't like a secondary drive without a primary.
> >
> > Being hdb instead of sdb with a new kernel indicates he is using a config
> > which may get a lot less testing these days, perhaps?
> >
> > In any case, I doubt he had two bad drives, so something else is more
> > likely.
> >
> 
> But earlier both was working fine on some another machines.

Did you try them before on this machine?

Another machine may mean another controller and entirely different
IDE host driver.

Your bugreport is too sparse in information to say more
(please at least post IDE related kernel config part).

Thanks,
Bart
