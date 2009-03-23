Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZCWP4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZCWP4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZCWPzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:55:54 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48433 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZCWPzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:55:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: philipp.reisner@linbit.com, gregkh@suse.de
Subject: [PATCH 00/12] DRBD: a block device for HA clusters
Date: Mon, 23 Mar 2009 16:47:55 +0100
Message-Id: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a series of patches aimed at integrating DRBD (www.drbd.org) into
upstream linux kernel. DRBD is a shared-nothing replicated storage device
that's a commonly encountered building block in high availability clusters.

For a variety of reasons now obsolete, DRBD has been maintained as an out of
tree module for 9 years and counting. We, the DRBD developers, would like to
fix that and would like to encourage everybody to review our code, tear it
apart and break it to pieces, so we can ultimately get this to merge.

Only the first patch is self contained (the lru_cache). The other parts of
the patch are split on file boundaries, but are not self contained.

Cheers,
 Phil (writing on behalf of the DRBD developer community)
