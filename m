Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXHTNJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXHTNJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbXHTNJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:09:13 -0400
Received: from maggie.spheresystems.co.uk ([82.71.70.17]:55457 "EHLO
	maggie.spheresystems.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbXHTNJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:09:12 -0400
X-Greylist: delayed 3092 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 09:09:11 EDT
From: Andrew Bird <ajb@spheresystems.co.uk>
To: linux-kernel@vger.kernel.org
Subject: MTD_WRITE called by a kernel timer OK in 2.4.20?
Date: Mon, 20 Aug 2007 13:17:35 +0100
User-Agent: KMail/1.9.3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708201317.35885.ajb@spheresystems.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	I'm trying to periodically write to flash on a small embedded device I'm 
playing with. I want to sync a buffer to flash every 15 seconds if it's 
dirty. I'm using a 2.4.20 kernel(not my choice) and have connected my 
buffer_write routine to a kernel timer both directly and also via a tasklet 
initiated by a kernel timer. Both methods give me an oops when attempting to 
write the flash. Is there anything basically wrong with this method? Will 
MTD_WRITE not function in interrupt context? It works just fine when called 
from an ioctl.


Hope you can help


Andrew
