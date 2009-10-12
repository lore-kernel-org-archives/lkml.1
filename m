Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbZJLOt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbZJLOt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbZJLOt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:49:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59146 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932364AbZJLOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:49:57 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/2] ET131x regression fixes
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 12 Oct 2009 15:38:08 +0100
Message-ID: <20091012142816.20944.92471.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These fix an RX and a TX bug in the wrap handling logic when converting it
from a mass of bitfields. They'll apply before or after the big block I sent
earlier.
---

Alan Cox (2):
      et131x: Fix the add_10bit macro
      et131x: Correct WRAP bit handling


 drivers/staging/et131x/et1310_address_map.h |    2 +-
 drivers/staging/et131x/et1310_rx.c          |   20 ++++++++++++++------
 2 files changed, 15 insertions(+), 7 deletions(-)

-- 
The lunar night club was most disappointing - not atmosphere at all.

