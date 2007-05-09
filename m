Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbXEIUdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbXEIUdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXEIUcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:32:41 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40414 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbXEIUck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:32:40 -0400
Date: Wed, 9 May 2007 16:27:19 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/6] UML - IRQ stacks and smaller kernel stacks
Message-ID: <20070509202719.GA22474@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is 2.6.22 material.

This set adds a separate IRQ stack and reduces kernel stack size.
There is also some preparatory cleanup and a new mechanism to keep
track of how close kernel stacks are to exhaustion.

				Jeff
