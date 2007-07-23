Return-Path: <linux-kernel-owner+w=401wt.eu-S933990AbXGWUPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990AbXGWUPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbXGWUPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:15:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47068 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755053AbXGWUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:15:42 -0400
Date: Mon, 23 Jul 2007 13:15:40 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.23 compile failure - slab/slob interspanking
Message-ID: <20070723131540.27f11b89@schroedinger.engr.sgi.com>
In-Reply-To: <20070718001836.GA30154@linux-sh.org>
References: <Pine.LNX.4.64.0707172148310.27468@fbirervta.pbzchgretzou.qr>
	<20070718001836.GA30154@linux-sh.org>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 09:18:36 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> With the slab zeroing allocations cleanups Christoph stubbed in a
> generic kzalloc(), which was missed on SLOB. Follow the SLAB/SLUB
> changes and kill off the __kzalloc() wrapper that SLOB was using.

Patches conflicted it seems ....

Acked-by: Christoph Lameter <clameter@sgi.com>
