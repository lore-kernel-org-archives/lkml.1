Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbZBLMqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbZBLMqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760338AbZBLMoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:44:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34498 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760329AbZBLMoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:44:23 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20090212143.515129156@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/4] x86: MCE: Cleanups series
Date: Thu, 12 Feb 2009 13:43:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series adds a few selected cleanups for the x86 machine check
code. It's patches out of the previously submitted mce tree.

They have been all reviewed previously.

The biggest change is the rewritten MCE poller. This cleans up
the code significantly and also slightly improves the 
behavour. 

These cleanups are needed for followon patches.

This is submitted for 2.6.30. It was developed against 2.6.29-rc4,
but also applies to x86 tip as of today.

It applies on top of the earlier bug fix series.

-Andi
