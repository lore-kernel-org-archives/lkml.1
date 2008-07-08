Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYGHRAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYGHRAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbYGHQ5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:57:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:55136 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbYGHQ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:57:46 -0400
Date: Tue, 8 Jul 2008 09:38:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 0/17] Series to introduce WARN()... a WARN_ON() variant that
 takes printk arguments
Message-ID: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series introduces WARN(), which is a WARN_ON() variant that
takes printk() like arguments. This was done after both akpm and I hit
several cases where this would have been useful; in addition, with
WARN(), we put the printk string inside the -----[ cut here ]-----
section, making it more likely that users (and tools like kerneloops)
pick up the message in addition to just the bare WARNING.

The first few patches have been in -mm for a long time; the later ones
are newer and introduce more users of WARN().

