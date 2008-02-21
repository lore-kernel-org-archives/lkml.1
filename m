Return-Path: <linux-kernel-owner+w=401wt.eu-S1763529AbYBUHcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763529AbYBUHcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 02:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYBUHb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 02:31:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:42167 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYBUHb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 02:31:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SSYfTx2jbz9kY3meXZvAk6KqFtLeoSlFrbcpgw5IOmYiySr28h3iL6ziD5nfpVn7kKYFkqojH55BGA0yaa85Ae9shZoLlrOXtg7G5S3F3iRcyvWPsAkIjfCAGxSMAJAQwI3i3tCJOV/S0X+75Gga9inOUBqWvSmKsq7lwurpStg=
Subject: acpi: new sparse warnings in 2.6.25-rc2
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 Feb 2008 23:32:14 -0800
Message-Id: <1203579134.20345.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced between 2.6.25-rc1 and -rc2.

drivers/acpi/executer/exregion.c:369:8: warning: incorrect type in argument 3 (different type sizes)
drivers/acpi/executer/exregion.c:369:8:    expected unsigned int [usertype] *value
drivers/acpi/executer/exregion.c:369:8:    got unsigned long long [usertype] *value
drivers/acpi/executer/exregion.c: In function ‘acpi_ex_pci_config_space_handler’:
drivers/acpi/executer/exregion.c:369: warning: passing argument 3 of ‘acpi_os_read_pci_configuration’ from incompatible pointer type

Cheers,

Harvey

