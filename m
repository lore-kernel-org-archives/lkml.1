Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZA2XCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZA2XCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbZA2XBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:01:47 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:43698 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbZA2XBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:01:46 -0500
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, jmorris@namei.org,
       matthltc@us.ibm.com, zohar@linux.vnet.ibm.com
Subject: [PATCH 0/2] TPM: refactoring and integrity
Date: Thu, 29 Jan 2009 21:01:33 -0200
Message-Id: <cover.1233060433.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains a refactoring patch and integrity one. The first addresses Matt Helsley and Dave Hansen's comments on replacing the data[] vectors by packed structures making the code easier to read and debug and also consolidates most of the tpm_show_* functions. The second one provides an interface to read and extend PCR values, which is widely used by IMA.

Rajiv Andrade (2):
  TPM: sysfs functions consolidation
  TPM: integrity interface

 drivers/char/tpm/tpm.c |  532 ++++++++++++++++++++++-------------------------
 drivers/char/tpm/tpm.h |  140 +++++++++++++
 include/linux/tpm.h    |   35 ++++
 3 files changed, 424 insertions(+), 283 deletions(-)
 create mode 100644 include/linux/tpm.h

