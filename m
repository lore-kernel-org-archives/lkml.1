Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbZJMPAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbZJMPAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760116AbZJMPAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:00:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56969 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752119AbZJMPAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:00:48 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/2] SEP fixes
To: gregk@kroah.com, linux-kernel@vger.kernel.org, arndbergmann@googlemail.com
Date: Tue, 13 Oct 2009 15:48:38 +0100
Message-ID: <20091013144716.31420.47979.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix next build breakage and remove un-needed use of lock BKL ioctl path
---

Alan Cox (2):
      sep: Fix use of legacy ioctl fop
      sep: Fix build problems from header changes


 drivers/staging/sep/sep_driver.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

-- 
How do you keep an idiot in suspense...
