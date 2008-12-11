Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbYLKTQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbYLKTQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbYLKTQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:16:41 -0500
Received: from kumera.dghda.com ([80.68.90.171]:39554 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111AbYLKTQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:16:40 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/11] make link target handling more robust
Date: Thu, 11 Dec 2008 19:16:24 +0000
Message-Id: <1229022995-9898-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix potential bugs associated with link target handling,
primarily by NULL-terminating names read from disk.

The ext2 and generic page_getlink changes have been tested by listing
corrupted links and creating and listing valid ones. Other patches have
been compile-tested only.

Cheers,
Duane.
