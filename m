Return-Path: <linux-kernel-owner+w=401wt.eu-S934330AbXJSRft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330AbXJSRft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXJSRfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:35:42 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:34761 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762765AbXJSRfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:35:42 -0400
Message-ID: <4718EAEA.9000609@freescale.com>
Date: Fri, 19 Oct 2007 12:35:38 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: request_firmware() and in-kernel modules
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If my driver is compiled in-kernel (and I have module support turned 
off), can I still use request_firmware()?  If my driver is loaded before 
the file system drivers are loaded, how can a user process copy the 
firmware to the /sys/class/firwmare/.../data device?

