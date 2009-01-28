Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZA1KYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZA1KYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZA1KX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:23:57 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:48420 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947AbZA1KX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:23:56 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/6] input: resend of pending patches
Date: Wed, 28 Jan 2009 11:23:43 +0100
Message-Id: <1233138229-12489-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LS7aM-00058c-3G.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1LS7aM-00058c-3G 62ac3c4b5e27701b20252547d6ce78dc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

here are the outstanding input patches.

Cheers,
Henrik

Henrik Rydberg (6):
  input: bcm5974: Prepare for a new trackpad header type
  input: bcm5974: Add quad-finger tapping
  input: bcm5974: Add support for the Macbook 5 (Unibody)
  input: bcm5974: Augmented debug information
  input: Allow certain EV_ABS events to bypass all filtering
  input: Add a detailed multi-touch finger data report protocol (rev2)

 drivers/input/input.c         |   36 +++++++++++++++
 drivers/input/mouse/bcm5974.c |   99 ++++++++++++++++++++++++++++++----------
 include/linux/input.h         |   29 ++++++++++++
 3 files changed, 139 insertions(+), 25 deletions(-)

