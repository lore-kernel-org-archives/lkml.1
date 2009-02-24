Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbZBXP5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbZBXP5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbZBXP5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:57:32 -0500
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:50460 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755588AbZBXP5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:57:31 -0500
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [RFC PATCH 0/3] Introduce init() and exit() for platform_device
To: greg@kroah.com
Cc: s.hauer@pengutronix.de, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2009 17:57:26 +0200
Message-ID: <20090224155721.28880.31830.stgit@Programuotojas>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For changes and documentation about this fix please see:
[RFC PATCH 1/3] platform_device: add init() exit() callbacks

Other patches demonstrate how drivers can benefit from this change.

I have two questions:
1. Is init()/exit() OK? Or should I call it activate()/deactivate()?
   Other suggestions?
2. Now exit() returns nothing. Maybe it is better if it returned int?
   How to handle such exit failure?
