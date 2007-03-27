Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbXC0RaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbXC0RaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934052AbXC0RaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:30:09 -0400
Received: from verein.lst.de ([213.95.11.210]:49094 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934030AbXC0RaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:30:08 -0400
Date: Tue, 27 Mar 2007 19:29:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] fix arch/i386/kernel/marker.c compilation
Message-ID: <20070327172955.GA12509@lst.de>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <20070327165240.GD16477@stusta.de> <20070327171150.GA24349@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327171150.GA24349@Krystal>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 01:11:50PM -0400, Mathieu Desnoyers wrote:
> Hi Adrian,
> 
> Since kdebug.h seems to have moved from asm/ to linux/ in Andrew's tree, I
> guess the #include <asm/kdebug.h> should be removed ? linux/kdebug.h
> already includes asm/kdebug.h.

Yes, exactly.

