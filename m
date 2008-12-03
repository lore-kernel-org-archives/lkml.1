Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYLCT3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYLCT3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYLCT3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:29:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39553 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYLCT3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:29:13 -0500
Date: Wed, 3 Dec 2008 19:29:05 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Yet more ARM breakage in linux-next
Message-ID: <20081203192905.GA12502@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to be causing lots of ARM breakage:

lib/find_next_bit.c:183: error: implicit declaration of function '__fls'

Whoever's responsible, please fix this ASAP so I can see whether my fixes
I merged on Monday fix the previous set of ARM build errors in linux-next.
Thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
