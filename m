Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYIEMZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYIEMZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYIEMZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:25:38 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:29761 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYIEMZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:25:38 -0400
Message-Id: <48C14174.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 05 Sep 2008 13:25:56 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] x86: ticket spin lock adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending the four patches previously sent individually as a series
that would apply (a) to tip of linux-x86 and (b) on top of one another.

1: fix asm constraints
(formerly 2: use LOCK_PREFIX - no longer necessary)
2: factor out more common code
3: reduce instruction dependencies

Signed-off-by: Jan Beulich <jbeulich@novell.com>


