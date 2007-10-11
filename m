Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbXJKKxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbXJKKxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbXJKKwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:52:54 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58446
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751419AbXJKKwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:52:53 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-scsi@vger.kernel.org
Subject: Scsi on sparc build break in 2.6.23.
Date: Thu, 11 Oct 2007 05:52:48 -0500
User-Agent: KMail/1.9.6
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710110552.49129.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SCSI_SUNESP=y breaks the build in 2.6.23:

  LD      vmlinux
`scsi_esp_unregister' referenced in section `__ksymtab' of drivers/built-in.o: 
defined in discarded section `.exit.text' of drivers/built-in.o
make: *** [vmlinux] Error 1

Do you need my full .config to reproduce this?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
