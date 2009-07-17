Return-Path: <linux-kernel-owner+w=401wt.eu-S934223AbZGQIMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223AbZGQIMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 04:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934210AbZGQIMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 04:12:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57376 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934204AbZGQIMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 04:12:10 -0400
Date: Fri, 17 Jul 2009 09:11:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: joerg.roedel@amd.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/3] ARM:dma-mapping:Support DMA-API debugging facility
	on ARM
Message-ID: <20090717081149.GB3174@n2100.arm.linux.org.uk>
References: <1247328467-24985-1-git-send-email-tom.leiming@gmail.com> <d82e647a0907161702v19b4b3f2j44ea9b051eef9e18@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0907161702v19b4b3f2j44ea9b051eef9e18@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 08:02:08AM +0800, Ming Lei wrote:
> 2009/7/12  <tom.leiming@gmail.com>:
> > Hi,
> > This patch set introduces dma-api debugging facility on ARM, and is
> > against -rc2-next tree.
> >
> 
> Hi, Russell and All,
> 
> Care to give any suggestions or objections on the patches?

I don't think it's suitable, because our implementation calls back into
the DMA API for dma_map_sg() - this means that the debugging code will
end up seeing each scatterlist entry twice.  I'm not sure what effect
that will have, but it's probably not good.
