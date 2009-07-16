Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZGPIsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZGPIsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZGPIsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:48:05 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62719 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZGPIsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ZtNAaeeHpb4k8Es9gqpwXeoArlv3i3COgFj7OkhS/jFcXO/5TWetueU1q77vPCbinA
         /GyGhRvGk9tm/yEdX68r6iqRE5wbUVaLPoiGhx7BAOJtyZK9c3bhFnmjeOlSvAx9OVBo
         RNJzT+/qcQ9cqCK4QxE0fsgRS6GWwG2Hp2/aw=
MIME-Version: 1.0
Date: Thu, 16 Jul 2009 12:48:01 +0400
Message-ID: <a4423d670907160148n66760052wbef60e4a2c3c7941@mail.gmail.com>
Subject: next: sfi build fails when !CONFIG_ACPI
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-next <linux-next@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

drivers/sfi/sfi_core.c: In function 'sfi_init':
drivers/sfi/sfi_core.c:346: error: 'acpi_disabled' undeclared (first
use in this function)
drivers/sfi/sfi_core.c:346: error: (Each undeclared identifier is
reported only once
drivers/sfi/sfi_core.c:346: error: for each function it appears in.)


$ grep ACPI .config
# Power management and ACPI options
