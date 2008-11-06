Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbYKFXo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbYKFXo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 18:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYKFXou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 18:44:50 -0500
Received: from khc.piap.pl ([195.187.100.11]:57645 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYKFXou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 18:44:50 -0500
To: <linux-kernel@vger.kernel.org>
Cc: khali@linux-fr.org, i2c@lm-sensors.org
Subject: I2C from interrupt context?
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 07 Nov 2008 00:44:48 +0100
Message-ID: <m3bpws8ln3.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm updating my EEPROM console logger and have encountered a problem
- the logger (as any console) can be called with hardware interrupts
disabled and/or from interrupt context. It needs to write to I^2C
(using ARM (Xscale) GPIO) and possibly SMBUS-only EEPROM chip. Is it
at all supposed to be possible?
-- 
Krzysztof Halasa
