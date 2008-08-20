Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYHTQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYHTQku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYHTQkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:40:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42535 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYHTQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:40:39 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: robert.richter@amd.com, oprofile-list@lists.sourceforge.net
Subject: oprofile: Implement Intel architectural perfmon
Date: Wed, 20 Aug 2008 18:40:29 +0200
Message-Id: <1219250433-25516-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchkit implements architectural perfmon support in oprofile.
This allows to do generic profiling of a few standard events in all 
newer Intel CPUs, including Atom and Nehalem. The CPU describes
its event in CPUID so they can be used without knowing anything
about the CPU.

The code requires some changes to the oprofile userland, which
I am posting separately to the oprofile list.

-Andi
