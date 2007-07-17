Return-Path: <linux-kernel-owner+w=401wt.eu-S935260AbXGQTBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935260AbXGQTBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935149AbXGQTAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:00:15 -0400
Received: from inti.inf.utfsm.cl ([200.1.21.155]:44910 "EHLO inti.inf.utfsm.cl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935123AbXGQTAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:00:13 -0400
From: "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: v9fs-developer@lists.sourceforge.net
Subject: Compile failure with v9fs
Date: Tue, 17 Jul 2007 14:26:05 -0400
Message-Id: <11846967662438-git-send-email-vonbrand@inf.utfsm.cl>
X-Mailer: git-send-email 1.5.2.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0rc6 (inti.inf.utfsm.cl [0.0.0.0]); Tue, 17 Jul 2007 14:25:52 -0400 (CLT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch deletes an assignment to the variable p9_debug_level,
which is never defined and isn't used anywhere else I can see.

