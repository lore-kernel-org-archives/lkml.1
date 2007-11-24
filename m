Return-Path: <linux-kernel-owner+w=401wt.eu-S1751676AbXKXDtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbXKXDtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 22:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXKXDsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 22:48:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:52142 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXKXDsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 22:48:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WRsXhUo8gEy37f32/XXW2FvFjoOmIDcgsi4HqNxJR2D64iJDwEJrIKeMttBVubWIZafHOB5C7aFYsh/YumoT+bW75HfC0iwyYLial7S0b859n2ox9wLgBHLkfmWVPysoB0zzk11gWaXSHfDyPJnaYsPNGHHdiGDkAM5GJQhVmhw=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] NET: dmfe: don't access configuration space in D3 state
Date: Sat, 24 Nov 2007 05:48:27 +0200
User-Agent: KMail/1.9.6
Cc: Linux Netdev List <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200711230129.02570.maximlevitsky@gmail.com> <200711230130.15939.maximlevitsky@gmail.com> <4747962D.5010506@garzik.org>
In-Reply-To: <4747962D.5010506@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711240548.28165.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 November 2007 05:10:37 Jeff Garzik wrote:
> Maxim Levitsky wrote:
> >>From 7e24227257f315e52fe0b494dc1253d2a0ce5dff Mon Sep 17 00:00:00 2001
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Fri, 23 Nov 2007 01:15:36 +0200
> > Subject: [PATCH] NET: dmfe: don't access configuration space in D3 state
> >  Accidently I reversed the order of pci_save_state and
> >  pci_set_power_state in .suspend()/.resume() callbacks
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  drivers/net/tulip/dmfe.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> 
> applied #upstream-fixes, after hand-editing patch changelog taking by 
> git-am from email body
> 
> 
> 

Hi,

Thanks,
Next time I will be more careful with changelogs.

Best regards,
	Maxim Levitsky
