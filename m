Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZLYKWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZLYKWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 05:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZLYKWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 05:22:40 -0500
Received: from coloquinte.cristau.org ([91.121.16.100]:34884 "EHLO
	coloquinte.cristau.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZLYKWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 05:22:39 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Dec 2009 05:22:39 EST
Date: Fri, 25 Dec 2009 11:13:18 +0100
From: Julien Cristau <jcristau@debian.org>
To: Darren Jenkins <darrenrjenkins@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: drivers/gpu/drm/radeon: move a dereference below a NULL test
Message-ID: <20091225101318.GQ3003@radis.liafa.jussieu.fr>
References: <1261658670.3546.7.camel@ICE-BOX>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261658670.3546.7.camel@ICE-BOX>
X-Operating-System: Linux 2.6.32-trunk-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 23:44:30 +1100, Darren Jenkins wrote:

> If a NULL value is possible, the dereference should only occur after the
> NULL test.
> 
> Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
> diff --git a/drivers/gpu/drm/radeon/radeon_irq.c
> b/drivers/gpu/drm/radeon/radeon_irq.c
> index b79ecc4..2f349a3 100644
> --- a/drivers/gpu/drm/radeon/radeon_irq.c
> +++ b/drivers/gpu/drm/radeon/radeon_irq.c
> @@ -289,16 +289,16 @@ int radeon_irq_emit(struct drm_device *dev, void
> *data, struct drm_file *file_pr

Looks like your patches are whitespace-damaged.  You'll need to fix your
MUA...

Cheers,
Julien
