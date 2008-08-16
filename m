Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYHPUZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYHPUZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYHPUY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:24:57 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33227 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYHPUY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:24:57 -0400
Date: Sat, 16 Aug 2008 21:24:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: michael_e_brown@dell.com
Subject: [PATCH 0/2] Add Dell laptop driver
Message-ID: <20080816202452.GA3331@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds backlight and rfkill support for Dell laptops. It uses 
the DCDBAS driver to trigger the system management calls required for 
this, and parses the DMI tables itself in order to find the appropriate 
tokens. In future it should be possible to add LED control, but I don't 
have any appropriate machines right now for testing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
