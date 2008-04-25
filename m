Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYDYG1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYDYG1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 02:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYDYG1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 02:27:20 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:59356 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbYDYG1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 02:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UrWqCB794CiacYt6/k74rWP6uCZ5or6jwXn4kYMq9u8UXrneWumOyU0AHtSivnLBBiRcZ924qHidB/7qnGskd4ZMoSRbFWU3lp4sDIzwWjAVxZMAdppPv7+YarQIHzcpMPTP+/8q038l7tGKJF+doVlILPAfYgwPOC/uKtOG1qk=
Message-ID: <386072610804242327g18b28ef4wa8893c0756764103@mail.gmail.com>
Date: Fri, 25 Apr 2008 14:27:17 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Jeff Garzik" <jgarzik@pobox.com>
Subject: Re: [PATCH 2/3] [libata/BF54x]: Fix bug - Implement bfin ata interrupt handler to avoid "irq 68 nobody cared"
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Sonic Zhang" <sonic.zhang@analog.com>
In-Reply-To: <48116965.7030705@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209094676-20360-1-git-send-email-cooloney@kernel.org>
	 <1209094676-20360-3-git-send-email-cooloney@kernel.org>
	 <48116965.7030705@pobox.com>
X-Google-Sender-Auth: 63537114794d844e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 1:17 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> Bryan Wu wrote:
>
> > From: Sonic Zhang <sonic.zhang@analog.com>
> >
> > Return IRQ_HANDLED when bfin ata device is busy.
> >
> http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3513
> >
> > Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> > Signed-off-by: Bryan Wu <cooloney@kernel.org>
> > ---
> >  drivers/ata/pata_bf54x.c |  125
> ++++++++++++++++++++++++++++++++++++++++++++--
> >  1 files changed, 121 insertions(+), 4 deletions(-)
> >
>
>  AFAICS the two new functions you add should be (a) marked 'static' and (b)
> not marked 'inline'.
>
>  We avoid inline these days, preferring to let the compiler make the best
> choice for that platform/CPU.
>

No problem, I will fix it.

-Bryan
