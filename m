Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbXFMFuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbXFMFuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 01:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbXFMFuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 01:50:39 -0400
Received: from waste.org ([66.93.16.53]:60275 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbXFMFui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 01:50:38 -0400
Date: Wed, 13 Jun 2007 00:50:31 -0500
From: Matt Mackall <mpm@selenic.com>
To: linux@horizon.com
Cc: bgilbert@cs.cmu.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Message-ID: <20070613055030.GJ11166@waste.org>
References: <466D9FDB.2010305@cs.cmu.edu> <20070612050544.23957.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612050544.23957.qmail@science.horizon.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 01:05:44AM -0400, linux@horizon.com wrote:
> > I got this code from Nettle, originally, and I never looked at the SHA-1 
> > round structure very closely.  I'll give that approach a try.
> 
> Attached is some (tested, working, and public domain) assembly code for
> three different sha_transform implementations.  Compared to C code, the
> timings to hash 10 MiB on a 600 MHz PIII are:
> 
> The names are the order they were written in.  "One" is the lib/sha1.c
> code (547 bytes with -Os).  "Four" is a 5x unrolled C version (1106 bytes).

I'd like to see your version four.

-- 
Mathematics is the supreme nostalgia of our time.
