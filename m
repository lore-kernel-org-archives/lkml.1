Return-Path: <linux-kernel-owner+w=401wt.eu-S933411AbXKOXsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbXKOXsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXKOXr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:47:57 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:53281 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbXKOXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:47:56 -0500
Date: Thu, 15 Nov 2007 18:46:48 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: mm creation/destruction hooks
Message-ID: <20071115234648.GA10948@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The changelog for commit d6dd61c831226f9cd7750885da04d360d6455101 says
	arch_dup_mmap, which is called when a new mmap is created at fork

Is there a reason that you're not tracking mm creation in exec?

				Jeff
