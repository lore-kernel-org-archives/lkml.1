Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbZGHWcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbZGHWcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758019AbZGHWbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:31:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47042 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169AbZGHWbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:41 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <200907091231.681564770@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] [0/8] Remove old deprecated x86 old machine check code & some cleanups
Date: Thu,  9 Jul 2009 00:31:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchkit removes the old 32bit x86 machine check code. 
This was scheduled in feature-removal-schedule.txt for 2.6.32, so the
removal can be queued now.

Also a few minor fixes for issues I noticed while doing that.
They are all fairly harmless and more cleanups than real bug fixes.

And finally(mostly) addresses two of the left over review comments:
- moving the per bank state into a single structure. The CMCI ownership 
information is still separate for now because that would have needed more
restructuring, not appropiate for this "trivial" patch series
- centralize the calculation of MSR addresses

-Andi
