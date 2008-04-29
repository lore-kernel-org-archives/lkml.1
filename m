Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYD2BxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYD2BxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYD2BxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:53:01 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56021 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751242AbYD2BxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:53:00 -0400
Message-Id: <20080429015231.908196699@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 18:52:31 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 0/9] [RFC] x86: Merge thread_info_32/64 to thread_info.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset merges the 32 and 64 bit thread_info files into one.

First just move the stuff into a single file and then gradually extract common
code. Ends up with pretty small differences. Had some time last Saturday to
play with it. Feedback/takeover appreciated.

Patch against git tree of today.

-- 
