Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbXJLQBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbXJLQBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbXJLQBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:01:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:53864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbXJLQBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:01:39 -0400
Message-Id: <20071012155019.747515889@hasse.suse.de>
User-Agent: quilt/0.46-62.1
Date: Fri, 12 Oct 2007 17:50:19 +0200
From: Jan Blunck <jblunck@suse.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [patch 0/2] r/o bind mount fixes for 2.6.23-mm1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two small patches for 2.6.23-mm1 that fix some issues with the r/o
bind mount code. Besides that, I can see that you handle files opened by
dentry_open() somewhere. Nevertheless this files are also fput'ed later.

Regards,
Jan

-- 

