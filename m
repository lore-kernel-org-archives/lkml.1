Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbZAUPxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbZAUPxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZAUPxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:53:00 -0500
Received: from relay1.sgi.com ([192.48.179.29]:46596 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752631AbZAUPxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:53:00 -0500
Message-Id: <20090121155203.050238642@attica.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Wed, 21 Jan 2009 09:52:03 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>
Subject: [patch 0/3] V2 sgi-xpc: Fixups for two bugs and some cleanup.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches fix two difficult to detect bugs in
SGI's XPC.

Changes from V1:
 - Prefixed barrier operations with smp_
