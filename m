Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbXBVGSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbXBVGSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 01:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932899AbXBVGSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 01:18:11 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58305 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774AbXBVGSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 01:18:09 -0500
Message-ID: <45DD35BF.9010309@cs.helsinki.fi>
Date: Thu, 22 Feb 2007 08:18:39 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.9 (Macintosh/20061207)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Josef Sipek <jsipek@fsl.cs.sunysb.edu>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org, clameter@sgi.com
Subject: Re: [-mm patch] UNION_FS must depend on SLAB
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>	<20070220000810.GK13958@stusta.de>	<84144f020702192237k78a5045bl51e0871fb3cac253@mail.gmail.com>	<20070220151356.GA19239@filer.fsl.cs.sunysb.edu>	<20070221141944.af6001db.akpm@linux-foundation.org>	<20070222020036.GE5867@filer.fsl.cs.sunysb.edu> <20070221182657.57264123.akpm@linux-foundation.org> <45DD3574.9070801@cs.helsinki.fi>
In-Reply-To: <45DD3574.9070801@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> The ksize exports we can add later if unionfs is to be merged.

Actually, we probably don't need it after the krealloc optimizations. I 
think we need a new unionfs patch too... :)

				Pekka
