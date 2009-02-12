Return-Path: <linux-kernel-owner+w=401wt.eu-S1761399AbZBLWSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399AbZBLWSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759125AbZBLWSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:18:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37989
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758674AbZBLWSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:18:06 -0500
Date: Thu, 12 Feb 2009 14:17:59 -0800 (PST)
Message-Id: <20090212.141759.261399324.davem@davemloft.net>
To: airlied@gmail.com
Cc: benh@kernel.crashing.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space
 using pointer derefs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970902120323y4f16693dk77955c7c646ac744@mail.gmail.com>
References: <1234434959.29851.55.camel@pasglop>
	<20090212.030926.74125778.davem@davemloft.net>
	<21d7e9970902120323y4f16693dk77955c7c646ac744@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@gmail.com>
Date: Thu, 12 Feb 2009 21:23:13 +1000

> are you on a PCI or PCIE card, I've no idea what buses you have on sparc64.
> 
> On the PCI cards the GART table will always be in main memory.
> PCIE always in VRAM.

PCI-E
