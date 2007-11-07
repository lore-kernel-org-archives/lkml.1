Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbXKGVqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbXKGVqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 16:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbXKGVqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 16:46:23 -0500
Received: from zakalwe.fi ([80.83.5.154]:45232 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbXKGVqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 16:46:22 -0500
Date: Wed, 7 Nov 2007 23:46:21 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: net: skge breakage on 2.6.24-rc1
Message-ID: <20071107214621.GA8865@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After some bisecting, I found that net skge driver broke on

commit 7fb7ac241162dc51ec0f7644d4a97b2855213c32

My network card is:

0000:00:0e.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Marvell] (rev 12)

Linux cheradenine 2.6.24-rc1-dirty #15 Wed Nov 7 23:39:28 EET 2007 x86_64 GNU/Linux

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
