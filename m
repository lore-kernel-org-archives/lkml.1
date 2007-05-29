Return-Path: <linux-kernel-owner+w=401wt.eu-S1764094AbXE2Jyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764094AbXE2Jyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXE2JyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:54:25 -0400
Received: from verein.lst.de ([213.95.11.210]:39772 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbXE2JyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:54:25 -0400
Date: Tue, 29 May 2007 11:53:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Geert.Uytterhoeven@sonycom.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] ps3: FLASH ROM Storage Driver
Message-ID: <20070529095355.GA29351@lst.de>
References: <20070525083607.784351000@sonycom.com> <20070525083632.815300000@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525083632.815300000@sonycom.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 10:36:14AM +0200, Geert.Uytterhoeven@sonycom.com wrote:
> Add a FLASH ROM Storage Driver for the PS3:
>   - Implemented as a misc character device driver
>   - Uses a fixed 256 KiB buffer allocated from boot memory as the hypervisor
>     requires the writing of aligned 256 KiB blocks

Looks good, but please either make the driver aware of multiple devices
even if they can't happen currently, or alternatively error out in
->probe if of some reason it's called for a second device.

