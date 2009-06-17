Return-Path: <linux-kernel-owner+w=401wt.eu-S1765074AbZFQJM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765074AbZFQJM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbZFQJMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:12:22 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53927 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZFQJMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:12:21 -0400
Subject: [BUG] timer_migration interface accepts any number as input in
 2.6.30-git9
From: poornima nayak <mpnayak@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arun@linux.vnet.ibm.com
Content-Type: text/plain
Date: Wed, 17 Jun 2009 14:42:16 +0530
Message-Id: <1245229936.3345.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Timer migration interface /proc/sys/kernel/timer_migration in
2.6.30-git9 accepts any numerical value as input.
Steps to reproduce 
1. echo -6666666 > /proc/sys/kernel/timer_migration
2. cat /proc/sys/kernel/timer_migration
-6666666

1. echo 44444444444444444444444444444444444444444444444444444444444 > /proc/sys/kernel/timer_migration
2. cat /proc/sys/kernel/timer_migration
-1357789412

Expected behavior: Should 'echo: write error: Invalid argument' while
setting any value other then 0 & 1

Regards
Poornima

