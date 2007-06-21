Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbXFUVRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbXFUVRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXFUVRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:17:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38495
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755343AbXFUVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:17:31 -0400
Date: Thu, 21 Jun 2007 14:17:49 -0700 (PDT)
Message-Id: <20070621.141749.71568508.davem@davemloft.net>
To: hch@lst.de
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drop obsolete sys_ioctl export
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070621211517.GA25268@lst.de>
References: <20070621211517.GA25268@lst.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 Jun 2007 23:15:17 +0200

> sys_ioctl was only exported for our first version of compat ioctl
> handling.  Now that the whole compat ioctl handling mess is more or
> less sorted out there are no more modular users left and we can kill it.
> 
> There's one exception and that's sparc64's solaris compat module, but
> sparc64 has it's own export predating the generic one by years for that
> which this patch leaves untouched.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David S. Miller <davem@davemloft.net>
