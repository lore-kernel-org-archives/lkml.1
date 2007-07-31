Return-Path: <linux-kernel-owner+w=401wt.eu-S1760467AbXGaXZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760467AbXGaXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXGaXZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:25:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53894 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751393AbXGaXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:25:13 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Simple Performance Counters
Date: Tue, 31 Jul 2007 16:25:05 -0700
Message-Id: <11859243121802-git-send-email-clameter@sgi.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: simple-perf-counters
References: simple-perf-counters
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches implement a simple way to do performance counters using
the time stamp registers on various platforms. The functionality here has been
useful to me in the past when I had to investigate the performance of certain
code paths in the Linux kernel.

The patchset is useful as is for me. There have been requests to make this
functionality available in general. I'd appreciate if someone could step
forward to do this since I already have my hands in too many things.

The patchset can also be retrieved via GIT PULL from kernel.org

git pull git://git.kernel.org/pub/scm/linux/kernel/git/christoph/misc.git perfcount

