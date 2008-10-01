Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbYJAG7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbYJAG7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYJAG7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:59:34 -0400
Received: from mail86.messagelabs.com ([216.82.247.115]:39482 "HELO
	mail86.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751853AbYJAG7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:59:33 -0400
X-VirusChecked: Checked
X-Env-Sender: arasv@magtech.com.au
X-Msg-Ref: server-10.tower-86.messagelabs.com!1222844371!2472085!1
X-StarScan-Version: 5.5.12.14.2; banners=magtech.com.au,-,-
X-Originating-IP: [150.101.126.166]
Message-ID: <48E31FD2.3060805@magtech.com.au>
Date: Wed, 01 Oct 2008 16:59:30 +1000
From: Aras Vaichas <arasv@magtech.com.au>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to add suspend/resume functions to misc drivers?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to add suspend/resume functionality to a misc based driver.

Searching through the kernel for drivers that contain the keywords
"misc_register" and "suspend" I found that drivers/macintosh/via-pmu.c
seems to be what i was looking for.

Am I correct? Would this be the best example of adding suspend/resume
functionality to a misc driver?

background: my device driver is for an ARM at91rm9200 interfaced via the
static memory bus to an FPGA. Only one device ever exists in the system.
The driver is never removed during normal usage.

Aras

______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
