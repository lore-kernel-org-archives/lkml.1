Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbXK3V63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbXK3V63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbXK3V6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:58:16 -0500
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:51643 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbXK3V6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:58:15 -0500
Date: Fri, 30 Nov 2007 23:58:10 +0200
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: drivers/char/random.c:write_pool() -- cond_resched needed?
Message-ID: <20071130215810.d3m43bwobifihfiu@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In write_pool(), isn't cond_resched() needed after call to
add_entropy_words() because otherwise there can be large latencies
(think of command "dd if=/dev/zero of=/dev/random bs=100000000" ) ?

-- 
Do what you love because life is too short for anything else.

