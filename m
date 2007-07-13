Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXGMTTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXGMTTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbXGMTTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:19:04 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:55218
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759624AbXGMTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:19:03 -0400
Date: Fri, 13 Jul 2007 21:20:23 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/5] use mutex instead of semaphore in several drivers
Message-ID: <20070713192023.GD18159@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset converts semaphores that are used as mutexes to the
mutex API in the following drivers/code:

SPI core/init code
USB gadget serial
ELAN U132 adapter
Adutux
FTDI ELAN 

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             You must have a plan. If you don't have a plan,
               you'll become part of somebody else's plan
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
