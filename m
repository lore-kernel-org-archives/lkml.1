Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab0CNOsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 10:48:43 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41374 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab0CNOsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 10:48:42 -0400
Date: Sun, 14 Mar 2010 10:46:54 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: stefani@seibold.net
Subject: [PATCH] KFIFO:  kfifo_is_{full,empty} should return bools, not
 ints.
Message-ID: <alpine.LFD.2.00.1003141045050.5852@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For consistency with other kfifo routines, return bool, not int.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index bc0fc79..d6af6df 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -172,7 +172,7 @@ static inline unsigned int kfifo_len(struct kfifo *fifo)
  * kfifo_is_empty - returns true if the fifo is empty
  * @fifo: the fifo to be used.
  */
-static inline __must_check int kfifo_is_empty(struct kfifo *fifo)
+static inline __must_check bool kfifo_is_empty(struct kfifo *fifo)
 {
 	return fifo->in == fifo->out;
 }
@@ -181,7 +181,7 @@ static inline __must_check int kfifo_is_empty(struct kfifo *fifo)
  * kfifo_is_full - returns true if the fifo is full
  * @fifo: the fifo to be used.
  */
-static inline __must_check int kfifo_is_full(struct kfifo *fifo)
+static inline __must_check bool kfifo_is_full(struct kfifo *fifo)
 {
 	return kfifo_len(fifo) == kfifo_size(fifo);
 }


rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
