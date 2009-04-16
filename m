Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbZDPQOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbZDPQOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZDPQOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:14:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbZDPQOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:14:37 -0400
Date: Thu, 16 Apr 2009 12:14:35 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parisc/superio: fix build breakage
Message-ID: <20090416161435.GB21359@bombadil.infradead.org>
References: <1239893159-18112-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239893159-18112-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 06:45:59PM +0400, Alexander Beregalov wrote:
> Usage of parport_pc_probe_port was changed in 28783eb52
> (parport: Fix various uses of parport_pc).
> 
> It introduced this build error:
> drivers/parisc/superio.c: In function 'superio_parport_init':
> drivers/parisc/superio.c:437: error: too few arguments to function
> 				'parport_pc_probe_port'
> 
> Fix it.
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Hi Alexander,

Wei Yongjun sent this patch in a few days ago, and I've applied it, but
it appears I forgot to update patchwork or push out the fixes branch.

Cheers, Kyle
