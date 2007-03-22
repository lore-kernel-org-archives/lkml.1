Return-Path: <linux-kernel-owner+w=401wt.eu-S934110AbXCVQKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110AbXCVQKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933840AbXCVQJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:09:43 -0400
Received: from [198.99.130.12] ([198.99.130.12]:53365 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933913AbXCVQJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:09:38 -0400
Date: Thu, 22 Mar 2007 12:06:40 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 0/7 ] UML - Header cleanup
Message-ID: <20070322160640.GA6992@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are post-2.6.21 material, except that if the new definition of
ARRAY_SIZE goes to Linus, patch 1 in this series should go as well.

These patches are a response to the new ARRAY_SIZE.  UML had a
duplicate definition for the use of the userspace side of things,
which can't directly use kernel.h.  This header was included
everywhere, and had a random collection of stuff in it.

This series first gets UML building again by replacing the old
ARRAY_SIZE definition with one that expands to the same token
sequence.  Then user_util.h is dismantled, primarily into two, more
coherent headers, and deleted.  ARRAY_SIZE is reintroduced, but in a
header which is only included in userspace files, and in its old form,
so this version is lacking the extra typechecking.

The final patch in the series is unrelated to the rest - it adds
__init declarations to some functions which were lacking them.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
