Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbZDRCbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbZDRCbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 22:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZDRCb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 22:31:26 -0400
Received: from main.gmane.org ([80.91.229.2]:58888 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZDRCbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 22:31:25 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bojan Smojver <bojan@rexursive.com>
Subject: ext3 v. ext4 writeback mode
Date: Sat, 18 Apr 2009 02:31:09 +0000 (UTC)
Message-ID: <loom.20090418T022710-681@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 150.101.121.179 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko/2009032713 Fedora/3.0.8-1.fc10 Firefox/3.0.8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given this part of the diff between ext3.txt and ext4.txt in
Documentation/filesystems of 2.6.30-rc2, does that mean that ext4 in writeback
mode can still leave garbage in files after the crash?

-------------------------
 * writeback mode
-In data=writeback mode, ext3 does not journal data at all.  This mode provides
+In data=writeback mode, ext4 does not journal data at all.  This mode provides
 a similar level of journaling as that of XFS, JFS, and ReiserFS in its default
 mode - metadata journaling.  A crash+recovery can cause incorrect data to
 appear in files which were written shortly before the crash.  This mode will
-typically provide the best ext3 performance.
+typically provide the best ext4 performance.
-------------------------

Or is it just a quick cut'n'paste thing that never got rewritten?

--
Bojan

