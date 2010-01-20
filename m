Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220Ab0ATKog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0ATKog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078Ab0ATKo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:44:29 -0500
Received: from gw.wifiinternet.cz ([89.31.42.6]:35055 "EHLO monstr.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752811Ab0ATKo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:44:26 -0500
X-Greylist: delayed 1993 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 05:44:23 EST
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: michal.simek@petalogix.com, arnd@arndb.de, linux-arch@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, mingo@elte.hu,
       joerg.roedel@amd.com
Subject: Generic DMA - BUG_ON
Date: Wed, 20 Jan 2010 11:08:30 +0100
Message-Id: <1263982111-24123-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have this patch in my repo. I just added BUG_ON for dma ops.
The reason for that is if driver not setup ops correctly than
the system do bad access to any memory space without any visible reason.
BUG_ON points to it and helps to solve where the problem is.

Thanks for your review,
Michal



