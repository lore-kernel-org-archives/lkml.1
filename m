Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYG2SDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYG2SDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYG2SDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:03:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:37280 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYG2SDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:03:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vZ7zuAqfqHLGGwOrxj3+qV/cMFy7r8UrB2pSwEmdJpJz94v+ggpqgRO02ZjD/7PVh7
         fSBw/Igo9ArtjFw+n9v3coON1bVNxO1dHQ2CgY/ClaI1ZGuYgcLLyJkkWHMroVcJhxsc
         mV+GAsbH1bWUfuzwTX5zZdUVyT8yqXdckewUU=
Date: Tue, 29 Jul 2008 22:03:21 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sparc64 build failure at iommu.c
Message-ID: <20080729180321.GB32295@orion>
References: <20080729175418.GA32295@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729175418.GA32295@orion>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 09:54:18PM +0400, Alexander Beregalov wrote:
> Hi
> 
> It is double declaration.
> Kernel version is 2.6.27-rc1
> 
> In file included from arch/sparc64/kernel/iommu.c:21:
> arch/sparc64/kernel/iommu_common.h:40: error: static declaration of
> 'iommu_num_pages' follows non-static declaration
> include/linux/iommu-helper.h:11: error: previous declaration of
> 'iommu_num_pages' was here
It is duplicated bug report, sorry.
