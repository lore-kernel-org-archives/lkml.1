Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZEJTFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZEJTFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 15:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZEJTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 15:05:22 -0400
Received: from verein.lst.de ([213.95.11.210]:47593 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbZEJTFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 15:05:21 -0400
Date: Sun, 10 May 2009 21:05:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       Jim Paris <jim@jtan.com>, linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [PATCH 04/15] ps3vram: Replace mutex by spinlock + list
Message-ID: <20090510190505.GA23535@lst.de>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 04:01:13PM +0200, Geert Uytterhoeven wrote:
> Remove the mutex serializing access to the cache.
> Instead, queue up new requests on a list if the driver is busy.

This should use the bio list helpers moved into bio.h in commit
8f3d8ba20e67991b531e9c0227dcd1f99271a32c

