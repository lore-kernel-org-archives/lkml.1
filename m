Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbZFNVUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbZFNVUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 17:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbZFNVUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 17:20:33 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:36133 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754376AbZFNVUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 17:20:32 -0400
Date: Sun, 14 Jun 2009 22:20:18 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: dma-debug: check_for_stack background?
Message-ID: <20090614212018.GD20442@fluff.org.uk>
References: <4A3547DD.2010809@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3547DD.2010809@s5r6.in-berlin.de>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 08:56:29PM +0200, Stefan Richter wrote:
> Hi,
>
> it took a while but I finally noticed that the DMA debug facility warns  
> about mappings of on-stack memory.  What's the problem with that?  Are  
> there architectures which don't support such mappings, or is it a  
> question of caution not to DMA-map the stack?

I'm not sure if it is possible on all architectures, however the
DMA mapping documentation prohibts the use of stack memory.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
