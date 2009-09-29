Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZI2SRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZI2SRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZI2SRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:17:01 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:38410 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbZI2SQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:16:58 -0400
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Scott.Kilau@digi.com, greg@kroah.com
Subject: [PATCH 0/5] jsm: cleaning up structures
Date: Tue, 29 Sep 2009 15:16:54 -0300
Message-Id: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A serie of patches that clean the jsm structures.
There are a lot of fields there that were never used, 
and is now being removed

Breno Leitao (5):
  jsm: remove the ch_custom_speed field
  jsm: removing ch_old_baud field
  jsm: Remove ch_cpstime field
  jsm: Removing unused jsm_channel->ch_wopen field
  jsm: removing the field jsm_board->intr_count

 drivers/serial/jsm/jsm.h     |    8 --------
 drivers/serial/jsm/jsm_neo.c |    8 --------
 drivers/serial/jsm/jsm_tty.c |    2 --
 3 files changed, 0 insertions(+), 18 deletions(-)

