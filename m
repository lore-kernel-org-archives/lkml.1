Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYDFWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYDFWDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 18:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbYDFWDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 18:03:34 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:61700 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753640AbYDFWDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 18:03:33 -0400
Date: Sun, 6 Apr 2008 18:03:26 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: hannes@saeurebad.de
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 04/22 -v2] avr32: Use generic show_mem()
Message-ID: <20080406180326.0f35b26f@siona.local>
In-Reply-To: <20080404115231.162496419@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
	<20080404115231.162496419@skyscraper.fehenstaub.lan>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr 2008 13:51:41 +0200
hannes@saeurebad.de wrote:

> Remove arch-specific show_mem() in favor of the generic version.
> 
> This also removes the following redundant information display:
> 
> 	- free pages, printed by show_free_areas()
> 	- pages in slabs, printed by show_free_areas()
> 	- pages in swapcache, printed by show_swap_cache_info()
> 
> where show_mem() calls show_free_areas(), which calls
> show_swap_cache_info().
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> CC: Haavard Skinnemoen <hskinnemoen@atmel.com>

Looks good to me. Thanks!

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
