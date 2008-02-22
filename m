Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYBVQv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYBVQv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbYBVQv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:51:28 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:46238 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755338AbYBVQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:51:25 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc2 + smartd = hang 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 22 Feb 2008 17:51:22 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-ACL-Warn: Too high rate of unknown addresses received from you
X-Scan-Result: No virus found in message 1JSb7L-00063u-6G.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JSb7L-00063u-6G abf6606b30140b5964a2200ef9c55e31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Trying out 2.6.25-rc2 smartd always causes my box to hang. I can switch 
vt:s and the keyboard seems to work.

Using sysrq-e I noticed a callpath open -> ext3 -> journals -> sync_buffer -> 
io_scheduel -> generic_unplig_device.

I'd guess the open stems from smartd. Removing smartd from the startup, I'm 
now using rc2 fine...

I got a nice jpg showing it as well.

Known issue?

/A


