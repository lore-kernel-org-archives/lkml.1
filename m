Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbYEGBwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbYEGBwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbYEGBvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:51:25 -0400
Received: from cpe-74-67-183-96.rochester.res.rr.com ([74.67.183.96]:38034
	"EHLO sled2.internal.unixthugs.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754118AbYEGBvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:51:23 -0400
Message-Id: <20080508063557.757413878@suse.com>
User-Agent: quilt/0.46_cvs20080326-8
Date: Thu, 08 May 2008 02:35:57 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Subject: [patch 0/3] eliminate struct semaphore from reiserfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Reiserfs uses sems for a few different locks, but only uses them as
 mutexes. The following three patches replace the semaphores with
 mutexes.

 -Jeff

--
Jeff Mahoney
SuSE Labs


