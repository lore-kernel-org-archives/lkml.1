Return-Path: <linux-kernel-owner+w=401wt.eu-S932395AbXFSTFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbXFSTFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbXFSTE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:04:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47065 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbXFSTE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:04:57 -0400
Date: Tue, 19 Jun 2007 20:04:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] remove usage of memmem from scripts/kallsyms.c
Message-ID: <20070619190454.GB3830@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Paulo Marques <pmarques@grupopie.com>,
	Andrew Morton <akpm@osdl.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mike Frysinger <vapier@gentoo.org>
References: <4678013C.5090402@grupopie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4678013C.5090402@grupopie.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 05:15:56PM +0100, Paulo Marques wrote:
> 
> The only in-kernel user of "memmem" is scripts/kallsyms.c and it only 
> uses it to find tokens that are 2 bytes in size. It is trivial to 
> replace it with a simple function that finds 2-byte tokens.
> 
> This should help users from systems that don't have the memmem GNU 
> extension available.

Please add a comment describing why it's there so that it's not ripped
out again by the first janitor looking over the code.

