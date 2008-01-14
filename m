Return-Path: <linux-kernel-owner+w=401wt.eu-S1750873AbYANOTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750873AbYANOTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYANOS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:18:56 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:34888 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYANOSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:18:55 -0500
Date: Mon, 14 Jan 2008 07:18:54 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Mathieu Segaud <mathieu.segaud@regala.cx>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert drivers/scsi/ch.c to use unlocked_ioctl
Message-ID: <20080114141854.GJ18741@parisc-linux.org>
References: <1200317533-24643-1-git-send-email-mathieu.segaud@regala.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200317533-24643-1-git-send-email-mathieu.segaud@regala.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 02:32:13PM +0100, Mathieu Segaud wrote:
> +#include <linux/smp_lock.h>

You don't add any uses of lock_kernel() and there are none in the
driver currently.

> -	.owner        = THIS_MODULE,
> -	.open         = ch_open,
> -	.release      = ch_release,
> -	.ioctl        = ch_ioctl,
> +	.owner          = THIS_MODULE,
> +	.open           = ch_open,
> +	.release        = ch_release,
> +	.unlocked_ioctl = ch_ioctl,

If you're going to do the gratuitous reformatting, at least use tabs
instead of spaces.

Other than that, should be fine.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
