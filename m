Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbYCLMMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbYCLMMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbYCLMMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:12:46 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:36731 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYCLMMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:12:46 -0400
Message-Id: <20080312120920.929901000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 12 Mar 2008 13:09:20 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/2] lockdep vs recursive read locks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We seemed to have some lockdep trouble wrt recursive read locks. Today Gautham
asked me some specific questions about it, which led to these patches.

IIRC Hugh ran into something similar a while back. This hopefully fixes it.


