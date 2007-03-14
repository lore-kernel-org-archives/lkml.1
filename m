Return-Path: <linux-kernel-owner+w=401wt.eu-S1030878AbXCNUH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030878AbXCNUH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030882AbXCNUH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:07:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3934 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030883AbXCNUHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:07:55 -0400
Message-Id: <20070314194912.414925000@sirena.org.uk>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 19:49:12 +0000
From: broonie@sirena.org.uk
To: Jeff Garzik <jeff@garzik.org>, Tim Hockin <thockin@hockin.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] natsemi updates
X-Spam-Score: -2.8 (--)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains a minor cleanup and two bug fixes for the
natsemi driver:

 1. Always use accessor functions for the interrupt enable register.
 2. Fix NAPI to work with shared interrupts.
 3. Ensure interrupts are not lost if the RX state machine locks up.

--
"You grabbed my hand and we fell into it, like a daydream - or a fever."
