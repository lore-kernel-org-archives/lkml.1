Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZAIMZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZAIMZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZAIMZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:25:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57088 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbZAIMZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:25:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [Regression] swsusp cannot find resume device (sometimes)
Date: Fri, 9 Jan 2009 13:24:39 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091324.43308.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is a hibernation regression (from 2.6.28 and in fact from some later
2.6.28-git too) on my Toshiba Portege R500 that swsusp sometimes cannot find
its resume device.  Specifically, open_by_devnum() in swsusp_check()
(kernel/power/swap.c) fails.  This seems to happen at random, approximately
50% of the time.

I wonder if that might be caused by the Arjan's asynchrounous boot patches.

Thanks,
Rafael
