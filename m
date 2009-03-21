Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbZCUErT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbZCUErT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 00:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZCUEqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 00:46:48 -0400
Received: from kroah.org ([198.145.64.141]:46700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751343AbZCUEqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 00:46:46 -0400
Date: Fri, 20 Mar 2009 21:44:02 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] Staging: psb: fix build problem
Message-ID: <20090321044402.GA31734@kroah.com>
References: <20090320113522.GA26267@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320113522.GA26267@orion>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 02:35:22PM +0300, Alexander Beregalov wrote:
> drivers/staging/psb/psb_drv.c:1372: error: 'struct drm_minor' has no member named 'dev_root'
> drivers/staging/psb/psb_drv.c:1374: error: 'struct drm_minor' has no member named 'dev_root'
> drivers/staging/psb/psb_drv.c:1394: error: unknown field 'dri_library_name' specified in initializ
> drivers/staging/psb/ttm/ttm_pat_compat.h:40: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'pgprot_ttm_x86_wc'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Thanks for the patch.  I'll keep it around, but for now, I've dropped
the psb driver from the staging tree.  It needs to be reworked in a
different way.

thanks,

greg k-h
