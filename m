Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXKZVVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXKZVVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbXKZVVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:21:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45194 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbXKZVVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:21:37 -0500
Date: Mon, 26 Nov 2007 13:20:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] x86 allnoconfig memory model
Message-Id: <20071126132036.343e3ee0.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0711261258480.25688@schroedinger.engr.sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<20071126111320.69d0aead.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
	<20071126124730.34c43da1.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0711261258480.25688@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 13:00:03 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 26 Nov 2007, Randy Dunlap wrote:
> 
> > This patch allows allnoconfig to build cleanly.
> 
> Well this sortof works.
> 
> One can again select a memory model but there is only one to choose from.
> It would be best if the memory model selection would not occur.

Unfortunately I just dropped that patch because git-x86 has gone and
combined include/asm-x86/sparsemem_32.h and include/asm-x86/sparsemem_64.h
into the same file.

