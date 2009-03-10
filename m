Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZCJBeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZCJBeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZCJBd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:33:56 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:34288 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZCJBdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:33:55 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Subject: Fixing the i915 lock ordering
Date: Mon,  9 Mar 2009 18:33:49 -0700
Message-Id: <1236648831-18230-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a new patch series with a proposed fix for two of the paths
with lock ordering problems in i915.  If these look OK (in particular GTT
pwrite, which is the most important performance path), I'll work on
resolving the non-GEM issue and figuring out what we want to do about
execbuffers (either this plan, or krh's patch, or something with
get_user_pages and kmap).
