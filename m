Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZFZJFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZFZJFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbZFZJFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:05:20 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42914 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017AbZFZJFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:05:19 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 0/2] cfq-iosched: get rid of __GFP_NOFAIL
Date: Fri, 26 Jun 2009 11:05:18 +0200
Message-Id: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So these are the two patches that get rid of __GFP_NOFAIL in
the CFQ IO scheduler. It's been tested with injecting errors
into the cfqq allocation and verifying that it both triggers
and works as expected.

-- 
Jens Axboe

