Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYJMHKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYJMHKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 03:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYJMHJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 03:09:53 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:37902 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbYJMHJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 03:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SOP/jhTWs8hLDN4Z7ojD5+v5NTAxaNpYiOjZUUvCrgwYat24CcMwhA4RHZ/tHLadUt
         uFz6Q0fUuIcQtkELWhW1a/HoVNmWV9GhX8VDtA4C29v5XBWFH0iCz7mjlEjHWMdJh+SM
         gSwjlHM7IN1LtUqjfgrezrvcNhOHu6obxSElY=
Message-ID: <48F2F3E4.4030800@gmail.com>
Date: Mon, 13 Oct 2008 16:08:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Christian Mueller <Christian.Mueller@wdc.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>	<48EBFE9B.9070503@gmail.com>	<18674.4081.839329.116533@harpo.it.uu.se>	<48F2D9A8.1030502@gmail.com> <18674.62170.845285.407281@harpo.it.uu.se>
In-Reply-To: <18674.62170.845285.407281@harpo.it.uu.se>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Tejun Heo writes:
>  > > - hardreset in sata_promise seems broken. I'll take a closer look
>  > >   at that in about a week's time (I'll be busy with other work the
>  > >   next couple of days).
>  > 
>  > This looks like a rather serious problem, so please take a look at
>  > this.  Also, after the drive went down, does unplugging and replugging
>  > the signal cable fix the problem, if not does doing the same thing
>  > with the power cable make any difference?
> 
> I couldn't bring the port back up with any combination of signal/power
> cable hotplugging.

Heh.. that rules out drive firmware stuck in wonderland.

> Even rmmod sata_promise; modprobe sata_promise failed to bring the
> port back up. Hence my suspicion that hardreset is borked or doesn't
> kick in.

It looks like the controller requires harder or more proper kick in
the ass to return to sane state.  :-)

-- 
tejun
