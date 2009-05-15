Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbZEOD0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbZEOD0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 23:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZEOD0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 23:26:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:44759 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbZEOD0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 23:26:04 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: [v1 PATCH 0/2] EDAC: AMD8111 & AMD8131 Kconfig fixup
Date: Fri, 15 May 2009 11:26:44 +0800
Message-Id: <1242358006-28339-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 15 May 2009 03:25:43.0927 (UTC) FILETIME=[D48F8870:01C9D50C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Doug and Andrew,

These are two minor fixups for the AMD8111 and AMD8131 EDAC drivers.
The direct reference to device.bus_id should be replaced by dev_name().

Add their missing Makefile entires and introduce machine dependency to 
their Kconfig options in order to avoid the allmodconfig failure, which
I have no better idea to avoid although these chips are not specific to
Maple.

Best regards,

Harry
