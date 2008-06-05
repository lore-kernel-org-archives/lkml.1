Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbYFES0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbYFES0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYFES0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:26:37 -0400
Received: from smtp.movial.fi ([62.236.91.34]:51843 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbYFES0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:26:36 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] Remove BKL from the bfs driver
Date: Thu,  5 Jun 2008 21:26:35 +0300
Message-Id: <1212690397-25693-1-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This removes quite a few instances of BKL usage in the bfs
driver. Given the purpose and the user base of this driver,
I do not believe that a finer-granularity lock than the big
fat filesystem-wide mutex I have implemented here is needed.

Please consider.

Thanks,
Dmitri
