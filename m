Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbZLSO6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbZLSO6f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 09:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZLSO6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 09:58:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42534 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZLSO6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 09:58:34 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20091219358.549678091@firstfloor.org>
To: torvalds@linux-foundation.org, akpm@osdl.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [0/2] SYSCTL: Warn once for all legacy syctls
Date: Sat, 19 Dec 2009 15:58:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even with my recent patch to not warn for CTL_KERN,KERN_VERSION there
is still the theoretical possibility that some program who uses another
binary sysctl regularly will get a flooded syslog.

This patchkit changes this to only warn once for every possible binary sysctl.

-Andi

