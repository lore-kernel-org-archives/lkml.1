Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbYBWIKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbYBWIKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765428AbYBWIIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:08:35 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932617AbYBWIId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:33 -0500
Date: Sat, 23 Feb 2008 00:04:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: VT notifier fix for VT switch
Message-Id: <20080223000430.074b3648.akpm@linux-foundation.org>
In-Reply-To: <20080221202640.GA10976@implementation>
References: <20080221202640.GA10976@implementation>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 21:26:40 +0100 Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Notify when VT switch is complete.
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> --- linux-2.6.24-orig/drivers/char/vt.c	2008-01-25 09:32:06.000000000 +0100
> +++ linux-2.6.24-perso/drivers/char/vt.c	2008-02-21 15:51:13.000000000 +0100
> @@ -702,6 +702,7 @@
>  	if (is_switch) {
>  		set_leds();
>  		compute_shiftstate();
> +		notify_update(vc);
>  	}
>  }
>  

The changelog is too terse, sorry.  What is the reason for making this
change?  What are the user-visible effects of not having this change?  If
it fixes a bug, should it be backported to 2.6.24.x and earlier?

etcetera.
