Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYDGBa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYDGBa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 21:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbYDGBaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 21:30:18 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:26287 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756086AbYDGBaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 21:30:17 -0400
Date: Mon, 7 Apr 2008 10:29:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: hannes@saeurebad.de
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 17/22 -v2] sh: Use generic show_mem()
Message-ID: <20080407012956.GA11221@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, hannes@saeurebad.de,
	LKML <linux-kernel@vger.kernel.org>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan> <20080404115233.063454998@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404115233.063454998@skyscraper.fehenstaub.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 01:51:54PM +0200, hannes@saeurebad.de wrote:
> Remove arch-specific show_mem() in favor of the generic version.
> 
> This also removes the following redundant information display:
> 
> 	- free pages, printed by show_free_areas()
> 	- pages in slab, printed by show_free_areas()
> 	- pages in swapcache, printed by show_swap_cache_info()
> 
> where show_mem() calls show_free_areas(), which calls
> show_swap_cache_info().
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> CC: Paul Mundt <lethal@linux-sh.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
