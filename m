Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbXGAQY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbXGAQY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbXGAQYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:24:22 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:57749
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754621AbXGAQYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:24:21 -0400
Date: Sun, 1 Jul 2007 18:25:29 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/5] use mutex instead of semaphore in several drivers
Message-ID: <20070701162529.GC3940@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset converts semaphores that are used as mutexes to the
mutex API in the following drivers:

Megaraid Mailbox
Philips webcam
SMSC LPC47M192
Virtual Video
VLSI 82C147 IrDA controller
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              Insanity: doing the same thing over and over
                again and expecting different results
                            (Albert Einstein)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
