Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbZKEUVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbZKEUVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZKEUVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:21:08 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:12755 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZKEUVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:21:07 -0500
Subject: [PATCH v2 0/3] Documentation/vm/page-types enhancements
To: akpm@linux-foundation.org, fengguang.wu@intel.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Nov 2009 13:21:11 -0700
Message-ID: <20091105201846.25492.52935.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of teaching page-types to decode page flags directly from
the command line.

v1 -> v2:
	- Use Fengguang's implementation
	- Exit early when using new -d|--describe option

---

Alex Chiang (2):
      page-types: whitespace alignment
      page-types: exit early when invoked with -d|--describe

Wu Fengguang (1):
      page-types: learn to describe flags directly from command line


 Documentation/vm/page-types.c |   60 +++++++++++++++++++++++++++--------------
 1 files changed, 39 insertions(+), 21 deletions(-)

