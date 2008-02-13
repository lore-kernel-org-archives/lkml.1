Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbYBMOp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbYBMOp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYBMOpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:45:15 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35694 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYBMOpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:45:14 -0500
Message-ID: <47B30291.2040905@davidnewall.com>
Date: Thu, 14 Feb 2008 01:15:37 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Handshaking on USB serial devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider a USB-attached serial port that is set to do RTS/CTS (or
DSR/DTR) handshaking: What stops the kernel sending more data to it when
the remote end lowers CTS (or DTR)?
