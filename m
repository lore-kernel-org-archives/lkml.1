Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYLIRA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYLIRA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYLIRAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:00:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:41587 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYLIRAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:00:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=PdHhAe3mmM3WC0imi1SXvmxJ2d/ABU6NwRYd9CcPlS/AGv2U+MgtfvdZPUNllB6l4A
         kG+1BWnUjFeVotq4sDfzyEahZpMoTW5gNkFx25L8JZYdqEiTqFOF9vFCgikqBGe1y6SX
         IU7E6sm3S1XZJyHprJUVBk3ilX8PNayNSIWjY=
Message-ID: <493EA41C.5060607@gmail.com>
Date: Tue, 09 Dec 2008 18:00:12 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: axboe@kernel.dk, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/33] block: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 block/blk-softirq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index e660d26..ce0efc6 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -161,7 +161,7 @@ void blk_complete_request(struct request *req)
 }
 EXPORT_SYMBOL(blk_complete_request);
 
-__init int blk_softirq_init(void)
+static __init int blk_softirq_init(void)
 {
 	int i;
 

