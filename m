Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbXFUV0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbXFUV0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXFUV0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:26:05 -0400
Received: from mail.tpi.com ([198.107.51.143]:4122 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbXFUV0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:26:04 -0400
X-Greylist: delayed 1303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 17:26:04 EDT
Message-ID: <467AE7E1.4050805@canonical.com>
Date: Thu, 21 Jun 2007 15:04:33 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: lenb@kernel.org
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ACPI Regression on Dell E1501
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit e9e2cdb412412326c4827fc78ba27f410d837e6e breaks boot on a Dell
E1501 unless 'acpi=off' is specified (also tried nolapic and nohpet but
it made no substantive difference). This laptop is an 'AMD Turion(tm) 64
X2 Mobile Technology TL-50' CPU, but its booting 32 bit SMP (make
defconfig). No kernel built after this commit works for this platform.

There is no crash output, it just wedges after 'NET: Registered protocol
family 2'.

How can I debug this problem?

rtg
-- 
Tim Gardner tim.gardner@ubuntu.com
