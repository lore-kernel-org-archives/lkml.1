Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbXKYA2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbXKYA2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 19:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXKYA2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 19:28:14 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:43597 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbXKYA2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 19:28:13 -0500
Date: Sun, 25 Nov 2007 01:25:10 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3, 4GB RAM, swiotlb, r8169, out of space
Message-ID: <20071125002510.GA30759@electric-eye.fr.zoreil.com>
References: <200711242344.49958.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711242344.49958.alistair@devzero.co.uk>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan <alistair@devzero.co.uk> :
[...]
> The "choke" affects other devices on the system too, notably libata, which 
> does not recover gracefully. In my logs, I see a stream of:
> 
> DMA: Out of SW-IOMMU space for 7222 bytes at device 0000:04:00.0
> DMA: Out of SW-IOMMU space for 7222 bytes at device 0000:04:00.0

You are using jumbo frames, aren't you ?

-- 
Ueimor
