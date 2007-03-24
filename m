Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbXCXREo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbXCXREo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 13:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbXCXREo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 13:04:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:21855 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbXCXREm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 13:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=IqNpsxsva815PJtVqgbBX1vIPRazkApp+FfDNZK8OECaNXqTUDI4HFtd4ye2BtZPHDk9nDEPcx8uScRC5/sxZ6O7PhVvfDICKNastG0mrAkSykVqpYd8EaHDFwyHk40+WL4JztPehQxTIMzVfTDI/A/r+yQAXeyHr8EQBJ6cmBs=
Date: Sat, 24 Mar 2007 19:04:32 +0200
To: Brian Braunstein <brian@bristyle.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, rajesh_mish@yahoo.com
Subject: Re: PATCH: tun/tap driver hw address handling
Message-ID: <20070324170432.GA6016@Ahmed>
References: <45E6BF26.7080607@bristyle.com> <45E73715.9030909@qualcomm.com> <4604E7D2.3020704@bristyle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4604E7D2.3020704@bristyle.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Sat, Mar 24, 2007 at 01:56:50AM -0700, Brian Braunstein wrote:
> 
> Linus,
> 
>  According to Documentation/SubmittingPatches "bug fixes" or "obvious" 
> changes
>  should CCed to you, so this is why I have done this.
>

IMHO these days patches got reviewed on LKML, then tested enough on the
unstable -mm tree then it got added to mainline kernel. Subsystem maintaners
can also add patches directly to mainline if they're trivial enough.
 
> Note: This entire email can be found at
> http://bristyle.com/share/patch-tuntap-hw_addr_handling.txt
> 

I think No need for such two lines. everyone uses his favourite LKML archive.

>  Summary:
>    Fix tun/tap driver's handling of hw addresses.  Specifically, ensure 
> that
>    when the tun.dev_addr field is set, the net_device.dev_addr field gets
>    set to the same value.
> 
>  Background:
>    The device hw address is stored in 2 places, in the tun.dev_addr field,
>    and of course the net_device struct's dev_addr field.  It really 
> seems to
>    me that the tun.dev_addr field is redundant, and that anywhere it is 
> used

Editor/mailer wrapping your lines badly ?

> 
> --- linux-2.6.20.4-ORIG/drivers/net/tun.c       2007-03-23 
> 12:52:51.000000000 -0700
> +++ linux-2.6.20.4/drivers/net/tun.c    2007-03-24 01:36:59.000000000 -0700
> @@ -18,6 +18,11 @@

Please reread SubmittingPatches to know the canonical patch format (missing
Signed-off-by and others).

> /*
>  *  Changes:
>  *
> + *  Brian Braunstein <linuxkernel@bristyle.com> 2007/03/23
> + *    Fixed hw address handling.  Now net_device.dev_addr is kept 
> consistent
[Remaing patch]

Patch can't be applied or even read cause your mailer has mistakenly wrapped
its lines.

Regards,

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

