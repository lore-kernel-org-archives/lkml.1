Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZBWRuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZBWRuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZBWRuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:50:18 -0500
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:39885 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752331AbZBWRuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:50:16 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Support for multiple MSI
Date: Mon, 23 Feb 2009 12:27:56 -0500
Message-Id: <1235410082-5016-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, Linux supports multiple MSI-X interrupts per device, but only
a single MSI interrupt.  This patch series adds support to the generic
PCI code for supporting multiple MSI interrupts.  Architectures will
need to add support for multiple MSIs, and I have a patch to do that for
x86 (which needs some more work).  Getting this patch series in first
is important so we can start supporting this interface in drivers and
architectures independently.
