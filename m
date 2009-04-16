Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZDPLhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZDPLhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZDPLh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:37:28 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49072 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZDPLh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mTUJ1GoHaaLRK2zXVAak0GObIbuSx9x6qRnRLJSoK0u9UgsR3G0W1UXFXyq/FFCWik
         qFbO8cSPVcAUrAYw0vAZ/9t4gnRZZcxDIbxQ2EWofczb/ZFDnc6+D4+hGROp1x/tV2po
         2l9CWsYx1MjgnR9wlSadccwszwtFSIUmGBAXQ=
Subject: [BISECTED] [REGRESSION] "ACPI video: support _BQC/_BCL/_BCM
 methods that use index values" breaks ACPI video
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Zhao, Yakui" <yakui.zhao@intel.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 14:37:19 +0300
Message-Id: <1239881839.5981.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally bisected a acpi video regression on my aspire 5720G

Reverting commit 

"ACPI video: support _BQC/_BCL/_BCM methods that use index values"
commit 1a7c618a3f7bef1a20ae740df512eeba21397fa5.


Makes it work, otherwise /sys/class/backlight is empty, and I get error
messages when I press hardware keys to change brightness:

"ACPI: Failed to switch the brightness"


Best regards,
	Maxim Levitsky

