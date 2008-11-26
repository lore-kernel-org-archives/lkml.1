Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYKZVLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYKZVLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYKZVLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:11:42 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:50773 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYKZVLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:11:41 -0500
Date: Wed, 26 Nov 2008 14:11:40 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH 2/2] relatime: Allow making relatime the default behaviour
Message-ID: <20081126211140.GH25548@parisc-linux.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126195824.GB3541@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 07:58:24PM +0000, Matthew Garrett wrote:
> +#define MS_NORELATIME	(1<<24)	/* Disable relatie even if the default */

typo

Otherwise, looks good.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

Instead of using __setup, could we use core_param() for these two
parameters?  I'm not sure that core_param are exposed in /sys or /proc
anywhere ... if we could fix that, I think it'd simplify this patch
enormously.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
