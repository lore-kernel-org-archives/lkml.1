Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbXKAWXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbXKAWXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbXKAWXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:23:08 -0400
Received: from styx.suse.cz ([82.119.242.94]:59530 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759605AbXKAWXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:23:06 -0400
Date: Thu, 1 Nov 2007 23:23:05 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Subject: Differences in bitops argument types
Message-ID: <20071101222305.GA28830@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  I've just found out that operations like constant_test_bit() take pointer
of different types on different architectures. In particular, x86_64,
blackfin and frv take void * while i386, s390 and m68k take unsigned long
*. Is this intended difference? Wouldn't using void * everywhere be more
appropriate? Thanks for answer in advance.

								Honza
