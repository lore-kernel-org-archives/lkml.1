Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab0BKKYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:24:07 -0500
Received: from compulab.co.il ([67.18.134.219]:58069 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab0BKKYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:24:05 -0500
Message-ID: <4B73DAEE.5080400@compulab.co.il>
Date: Thu, 11 Feb 2010 12:24:46 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: [PATCH 0/3] Add Intel SCH GPIO driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LPC bridge controller of Intel SCH contains several functions.
Currently, LPC bridge controller PCI device is claimed by SMBus driver
thus disabling ability to have an additional driver for the LPC bridge
PCI device. This patch series introduces and MFD driver that creates
platform_device for both SMBus and GPIO controller, converts  SMBus
driver to platform_driver and adds the driver for GPIO controller
