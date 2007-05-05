Return-Path: <linux-kernel-owner+w=401wt.eu-S933340AbXEEU3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbXEEU3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbXEEU3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:29:37 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:38673 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265AbXEEU3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:29:36 -0400
Date: Sat, 5 May 2007 22:29:30 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: acpi_handle is intel only.
Message-ID: <20070505202930.GA6360@aepfle.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, Andrew Morton wrote:

> +gregkh-pci-pci-reduce-aer-init-error-information.patch

include/linux/pci-acpi.h:57: error: expected ')' before 'handle'
make[4]: *** [drivers/pci/pcie/portdrv_pci.o] Error 1

acpi_handle is intel only.
