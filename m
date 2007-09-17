Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbXIQP7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbXIQP7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbXIQP6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:58:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53114 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbXIQP6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:58:50 -0400
Date: Mon, 17 Sep 2007 17:59:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: git-send-email creates duplicate Message-Id's
Message-ID: <20070917155901.GP18232@stusta.de>
References: <11900179463203-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following might be a bug in git-send-email (git maintainers Cc'ed
and KVM list removed from Cc): 

Patch 54 got the same Message-Id as patch 61 and patch 89 got the same 
Message-Id as patch 104.

That's not legal, and users who automatically filter duplicate emails 
based on the Message-Id will not see two of the patches.

The emails are:
http://marc.info/?l=linux-kernel&m=119002061330270&w=2
http://marc.info/?l=linux-kernel&m=119002059626434&w=2
http://marc.info/?l=linux-kernel&m=119002060011801&w=2
http://marc.info/?l=linux-kernel&m=119002060318915&w=2

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

