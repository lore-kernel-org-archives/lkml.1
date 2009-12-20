Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZLTRTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZLTRTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZLTRS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:18:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbZLTRS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:18:59 -0500
Date: Sun, 20 Dec 2009 19:16:08 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 0/3] vhost: fix use_mm usage
Message-ID: <20091220171608.GA31713@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes an issue, pointed out by Al Viro, in how vhost net
calls use_mm, Works fine for me, and it's pretty straightforward.  If no
one sees any issues with it, this will be a good candidate for 2.6.33
(assuming vhost net itself gets pulled :( ).


Michael S. Tsirkin (3):
  vhost: prevent modification of an active ring
  vhost: add access_ok checks
  vhost: make default mapping empty by default

 drivers/vhost/net.c   |   23 ++++++--
 drivers/vhost/vhost.c |  153 ++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/vhost/vhost.h |    2 +
 3 files changed, 157 insertions(+), 21 deletions(-)

-- 
MST
