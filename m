Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbZCLNif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbZCLNif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZCLNiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:38:24 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49396 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbZCLNiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:38:23 -0400
Date: Thu, 12 Mar 2009 14:38:19 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: System tick rate
Message-ID: <alpine.LSU.2.00.0903121435190.3835@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


is there an "official" way of obtaining the current tick rate when 
CONFIG_NO_HZ? This is for a simple statistics display tool. Counting the 
interrupts from /proc/interrupts (calculating the difference between two 
timepoints) seems to work, though I have seen at least one x86 machine 
where both IRQ0 and the LOC counters increase, making it not entirely 
obvious which number to take as a base. Suggestions?
