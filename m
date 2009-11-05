Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZKEGO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZKEGO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZKEGO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:14:26 -0500
Received: from kroah.org ([198.145.64.141]:48254 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZKEGOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:14:25 -0500
Date: Wed, 4 Nov 2009 22:14:13 -0800
From: Greg KH <greg@kroah.com>
To: Sebastian Dalfu?? <sd@sedf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/3] staging: rt2860: remove reading a file from /etc
Message-ID: <20091105061413.GA30901@kroah.com>
References: <20091105060654.GA8664@sedf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105060654.GA8664@sedf.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 07:06:54AM +0100, Sebastian Dalfu?? wrote:
> From: Sebastian Dalfu?? <sd@sedf.de>
> Subject: [Patch 1/3] staging: rt2860: remove reading a file from /etc
> 
> This patch is based on 2.6.32-rc6
> 
> This patch removes the whole ugly reading-from-/etc stuff.
> No lines are added or modified, but a lot of lines (for loading and
> parsing the file from /etc) are removed. Nearly all removed lines had
> been in rt_profile.c, rest is header and the call of
> RTMPReadParametersHook() in rt_main_dev.c.
> 
> Signed-off-by: Sebastian Dalfu?? <sd@sedf.de>
> ---
> diff -ru a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
> --- a/drivers/staging/rt2860/rt_linux.h	2009-11-03 20:37:49.000000000 +0100
> +++ b/drivers/staging/rt2860/rt_linux.h	2009-11-04 23:49:52.382174611 +0100

This doesn't apply to my tree, as this file is deleted there.  Can you
please rediff these 3 patches against the linux-next tree as I asked so
that they can be applied?

thanks,

greg k-h
