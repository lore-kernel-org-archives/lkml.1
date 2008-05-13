Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbYEMWzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbYEMWzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYEMWzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:55:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:5047 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbYEMWzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:55:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,481,1204531200"; 
   d="scan'208";a="246383669"
Subject: Re: [PATCH 1/1] dma:
From: Dan Williams <dan.j.williams@intel.com>
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Cc: linux <linux-kernel@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
In-Reply-To: <20080512205052.C1DFB7000085@mwinf2b01.orange.fr>
References: <20080512205052.C1DFB7000085@mwinf2b01.orange.fr>
Content-Type: text/plain; charset=utf-8
Date: Tue, 13 May 2008 15:55:06 -0700
Message-Id: <1210719306.26026.89.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-12 at 13:50 -0700, Christophe Jaillet wrote:
> ï»¿From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> Hi, here is a patch against linux/drivers/dma/iop-adma.c which :
>        
> 1) Remove an explicit memset(.., 0, ...) to a variable allocated with
> kzalloc (i.e. 'dest').
> 
> 2) Allocate 'src' with kmalloc instead of kzalloc as all elements of
> the
> 'src' buffer are initialized in a 'for(...)' loop just after.
> 
> 3) remove useless 'sizeof(u8)', which always returns 1, when computing
> the
> size of the memory to be allocated.
> 
> 
> Note: this patch is based on 'linux-2.6.25.tar.bz2'
> 
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Thanks, applied.

--
Dan

