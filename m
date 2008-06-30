Return-Path: <linux-kernel-owner+w=401wt.eu-S1759649AbYF3Kgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649AbYF3Kgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYF3Kgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:36:33 -0400
Received: from 217-133-41-173.b2b.tiscali.it ([217.133.41.173]:14346 "EHLO
	PowerMacG5.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751385AbYF3Kgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:36:32 -0400
X-Greylist: delayed 1905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2008 06:36:32 EDT
Mime-Version: 1.0
Message-Id: <p0624081dc48e6036b8f4@[192.168.168.51]>
Date: Mon, 30 Jun 2008 12:04:42 +0200
To: linux-kernel@vger.kernel.org
From: Barbara Picci <barbara.picci@sardi.it>
Subject: Help with Hardening Linux
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm a server administrator (Dell PowerEdge). I usually use Debian.

Before now I used lcap to disable some capabilities (with success 
with kernel 2.4).

Now I'm configuring some machines with Debian etch and kernel 2.6.25.
I enable with makemenuconfig "Enable different security models" >> 
"Default Linux Capabilities" and my .config is:

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_CAPABILITIES=y
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0

I try to install lcap_0.0.6-3.1_i386.deb from packages.debian.org 
but, if I louch lcap, instead of the list of capabilities, I've:

/proc/sys/kernel/cap-bound: No such file or directory

I googled on forums, sites, etc. but I can't find a solution.

Thanks in advance
Barbara Picci
-- 
