Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbXLNFEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbXLNFEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 00:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbXLNFEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 00:04:22 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57839 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbXLNFEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 00:04:21 -0500
Message-Id: <200712140504.lBE54Jpa044093@www262.sakura.ne.jp>
Subject: [2.6.24-rc5-mm1] Why CONFIG_BLK_DEV_RAM=m makes \"#ifdef CONFIG_BLK_DEV_RAM\" false?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Dec 2007 14:04:19 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I found that

 CONFIG_BLK_DEV_RAM=m

in my .config makes

 #ifdef CONFIG_BLK_DEV_RAM

false.

I guess something is wrong with .config parsing.

Regards.
