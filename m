Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbZAGW6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbZAGW6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZAGW56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:57:58 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:3544 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZAGW55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:57:57 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KD4IG2-02-ZH2-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/9] oprofile: implement support of samples with variable data size
Date: Wed, 7 Jan 2009 23:45:16 +0100
Message-ID: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
X-OriginalArrivalTime: 07 Jan 2009 22:57:46.0382 (UTC) FILETIME=[5B229AE0:01C9711B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements support of samples with variable data
size. Current implementation has a fixed sample size of 2 unsigned
longs. This makes it hard to implement use cases with a different
sample size (AMD IBS or power pc cell) since buffer locking is
required or samples my become incomplete. The internal cpu buffer
usage has been changed now and allows the attachment of data with
varable length to samples.

There are patches that also change the current ibs implementation. In
the end the ibs implentation could be removed from the general
oprofile code to model specific code. An API is available that
provides generic functions to use variable sample sizes.

The patches are also available here:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git oprofile-for-tip

-Robert



