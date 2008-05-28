Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbYE1EKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbYE1EKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 00:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYE1EJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 00:09:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42345 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbYE1EJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 00:09:57 -0400
Date: Tue, 27 May 2008 21:09:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Fede <fedux@lugmen.org.ar>
Cc: linux-kernel@vger.kernel.org
Subject: Re: bad pmd ffff810000207238(9090909090909090).
Message-ID: <20080527210924.0537cb44@infradead.org>
In-Reply-To: <483CBCDD.10401@lugmen.org.ar>
References: <483CBCDD.10401@lugmen.org.ar>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 23:01:01 -0300
Fede <fedux@lugmen.org.ar> wrote:

> Hi,
> 
> Today I tried to start a firewalling script and failed due to an 
> unrelated issue, but when I checked the log I saw this:
> 
> May 27 20:38:15 kaoz ip_tables: (C) 2000-2006 Netfilter Core Team
> May 27 20:38:28 kaoz Netfilter messages via NETLINK v0.30.
> May 27 20:38:28 kaoz nf_conntrack version 0.5.0 (16384 buckets, 65536
> max) May 27 20:38:28 kaoz ctnetlink v0.93: registering with nfnetlink.
> May 27 20:38:28 kaoz ClusterIP Version 0.8 loaded successfully
> May 27 20:38:28 kaoz mm/memory.c:127: bad pmd 
> ffff810000207238(9090909090909090).


909090 is asm for "nop nop nop", a pattern often used in rootkits to
deal with slightly unknown memory locations



I would REALLY REALLY strongly suggest that you check for rootkits and
the like on your system...



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
