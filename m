Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZFXPam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZFXPam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZFXPae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:30:34 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:55588 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbZFXPae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:30:34 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, hjk@linutronix.de
Subject: Two small UIO patches
Date: Wed, 24 Jun 2009 17:30:23 +0200
Message-Id: <1245857425-25389-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was planning to use the UIO layer for a driver I was working on and
liked the aproach a lot.

Eventually I didn't use it because there were registers which needed to
know the physical address of a shared memory area which is not easily
doable with that framework.

However, my way I stumbled over two small things which I would still
like to share. One is adds the support for device clocks, the other one
is a nit-picking cleanup.

Daniel

[PATCH 1/2] UIO: add device clock support
[PATCH 2/2] UIO: remove 'default n' from Kconfig
