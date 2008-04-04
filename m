Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbYDDOb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbYDDOb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759606AbYDDOay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:30:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759599AbYDDOax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:30:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080404115232.479618744@skyscraper.fehenstaub.lan>
References: <20080404115232.479618744@skyscraper.fehenstaub.lan> <20080404115137.397502419@skyscraper.fehenstaub.lan>
To: hannes@saeurebad.de
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 13/22 -v2] mn10300: Use generic show_mem()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 04 Apr 2008 15:30:49 +0100
Message-ID: <1443.1207319449@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hannes@saeurebad.de wrote:

> Remove arch-specific show_mem() in favor of the generic version.
> 
> This also removes the following redundant information display:
> 
> 	- free pages, printed by show_free_areas()
> 	- pages in swapcache, printed by show_swap_cache_info()
> 
> where show_mem() calls show_free_areas(), which calls
> show_swap_cache_info().
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: David Howells <dhowells@redhat.com>
