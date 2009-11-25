Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbZKYKFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbZKYKFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758573AbZKYKFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:05:45 -0500
Received: from smtp.nokia.com ([192.100.105.134]:17426 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567AbZKYKFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:05:44 -0500
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Cc: peter.de-schrijver@nokia.com, eduardo.valentin@nokia.com,
       ext-juha.1.keski-saari@nokia.com
Subject: [PATCHv2 0/3] for-next: Add all twl4030 regulators to RegFW
Date: Wed, 25 Nov 2009 12:04:52 +0200
Message-Id: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 25 Nov 2009 10:05:01.0309 (UTC) FILETIME=[C0696AD0:01CA6DB6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Liam,

This series is a revision of an earlier patch which was sent before.
The previous patch was split and now these changes are against voltage-2.6
tree, branch for-next.

There are two new modification. So now this series contains:
- Add all twl4030 regulators to the RegFW and 
- make sure the REMAP configuration of each regulator is as after reset. 
- Also defines critical regulators as always-on since it is not feasible
to allow them to be disabled in a case where the RegFW is used

These are only modifications on the twl4030 regulator driver. Changes to
the mfd driver will be sent separately

BR,

Juha Keski-Saari (3):
  twl4030-regulator: Add all TWL regulators to twreg_info
  Reset REMAP configuration in regulator probe
  Define critical regulators as always_on

 drivers/regulator/twl4030-regulator.c |   48 +++++++++++++++++++++++---------
 1 files changed, 34 insertions(+), 14 deletions(-)

