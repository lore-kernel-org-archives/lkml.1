Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbYEPTDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbYEPTDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYEPTD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:03:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488AbYEPTD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:03:28 -0400
Message-ID: <482DDA56.6000301@redhat.com>
Date: Fri, 16 May 2008 14:02:46 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jamie Lokier <jamie@shareable.org>
Subject: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, that last send was totally stuffed up w.r.t. mail headers.

So for the benefit of proper cc:'s here it comes again...

A collection of patches to make ext3 & 4 use barriers by
default, and to call blkdev_issue_flush on fsync if they
are enabled.

