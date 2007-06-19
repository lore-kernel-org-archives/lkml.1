Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbXFSSnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbXFSSnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758787AbXFSSnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:43:07 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53308 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760770AbXFSSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:43:06 -0400
Date: Tue, 19 Jun 2007 14:42:44 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] UML stack tweaks
Message-ID: <20070619184244.GA10557@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These can wait till 2.6.23.

They use get_free_page instead of kmalloc to allocate kernel stacks
and add some stack usage monitoring under CONFIG_DEBUG_STACK_USAGE.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
