Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbZJOQyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbZJOQyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbZJOQyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:54:00 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:49135 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbZJOQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uenFXib1m+k7UzIQK61MggLcIsFdD4fgcZGEGeN9C/bC51ILK8CMVPaILrFiSVDELs
         aR+1wLaJ0xAb306OqoFbnUWhYK30jDExgE3BX5WyxVHssgie3vS8xFOGNY22q4rb/39g
         2NIGK9SqGumJRMbThgTp9cAEjtOSXBHCoKTYk=
Date: Thu, 15 Oct 2009 20:53:20 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Russell King <linux@arm.linux.org.uk>,
       Eric Miao <eric.y.miao@gmail.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Anton Vorontsov <cbouatmailru@gmail.com>, linux-mtd@lists.infradead.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH] mtd: maps: remove obsolete ipaq-flash driver
Message-ID: <20091015165320.GA24086@oksana.dev.rtsoft.ru>
Reply-To: cbouatmailru@gmail.com
References: <1255433694-26471-1-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1255433694-26471-1-git-send-email-mad_soft@inbox.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 03:34:54PM +0400, Dmitry Artamonow wrote:
> This driver seems to be obsolete and broken for a long time.
> It depends on CONFIG_IPAQ_HANDHELD that simply doesn't exists
> anywhere in kernel. Also, it seems that none of machines it
> claims to support have any use of it:
>  SA11xx-based iPAQs (h3100/h3600) use sa1100-flash
>  iPAQ h5000 uses physmap-flash
>  Jornada 720 uses sa1100-flash
>  Jornada 560 and iPAQ h1910 are not in mainline
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
