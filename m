Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbYAUFdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbYAUFdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 00:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYAUFcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 00:32:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:59658 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751675AbYAUFcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 00:32:53 -0500
X-Authenticated: #759291
X-Provags-ID: V01U2FsdGVkX1/oDlJJfj7oSpE5ltOWUo7BDWWITUFPJeAfRH5o1c
	5twUpg0yJZZhDU
From: Matthias Wolle <Matthias.Wolle@gmx.de>
Reply-To: Matthias Wolle <Matthias.Wolle@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: LowFree/LowMem problem
Date: Mon, 21 Jan 2008 06:32:41 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801210632.42497.Matthias.Wolle@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my company is running several servers with kernel 2.6.23.12.  This are Dual 
Quad Core servers (CPU Intel) with 16GB RAM using a 32Bit kernel.
After some days nicely running the oom killer killed our processes.
Our research discovered that the free low memory was reduced to about 11MB. We 
found out that the decreasing of low memory is related to the count off 
executed and ended programs.

I could reproduce the same bug on a maschine with 2GB RAM without PAE (option 
4GB HIGHMEM). The following code reproduces the bug.

#!/bin/sh

while [ true ]; do
	cat /proc/meminfo| grep LowFree
done

Please run this script only on a test system. It reduces the low memory quite 
fast (within minutes). 

The latest available kernel 2.6.24-rc8 is also affected.

Please fell free to request more information from me.
Please always CC to me, I'm not subscribed.

Thanks for reading

Matthias
