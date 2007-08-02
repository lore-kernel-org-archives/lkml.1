Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbXHBNGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbXHBNGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXHBNG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:06:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52104 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbXHBNGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:06:25 -0400
Subject: Re: mmap behavior on out-of-space conditions
From: Peter Zijlstra <peterz@infradead.org>
To: Petr Tesarik <ptesarik@suse.cz>, Dave Chinner <dgc@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1186058486.2289.17.camel@elijah.suse.cz>
References: <1186058486.2289.17.camel@elijah.suse.cz>
Content-Type: text/plain
Date: Thu, 02 Aug 2007 15:06:15 +0200
Message-Id: <1186059975.12034.111.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 14:41 +0200, Petr Tesarik wrote:
> Hello,
> 
> while solving a different issue, my colleague Libor Pechacek found a
> problem with handling mmapped sparse files. If you mmap the hole insidea
> sparse file and write to it, the data gets silently lost if there is not
> enough space left on the underlying device.

I think Dave's block_page_mkwrite() stuff addresses this as well, no?

http://lkml.org/lkml/2007/3/18/198

Peter

