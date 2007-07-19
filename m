Return-Path: <linux-kernel-owner+w=401wt.eu-S937141AbXGSI4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937141AbXGSI4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbXGSI4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:56:46 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:20922 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758381AbXGSI4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:56:45 -0400
Date: Thu, 19 Jul 2007 12:56:41 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org
Subject: CONFIG_PM=n, CONFIG_ACPI_PROCESSOR=y breakage
Message-ID: <20070719085641.GA11064@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

make randconfig generated such config, or you can DYI via

a) make allyesconfig
b) make menuconfig
c) go straight to Power Management, turn it off
d) exit immediately, save .config

  CC      arch/i386/kernel/acpi/cstate.o
In file included from arch/i386/kernel/acpi/cstate.c:17:
include/acpi/processor.h:88: error: expected specifier-qualifier-list before 'acpi_integer'
	...

