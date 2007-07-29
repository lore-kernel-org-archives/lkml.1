Return-Path: <linux-kernel-owner+w=401wt.eu-S936989AbXG2V3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936989AbXG2V3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935584AbXG2V3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:29:18 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:40953
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S935684AbXG2V3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:29:17 -0400
Date: Sun, 29 Jul 2007 23:29:09 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/5] use mutex instead of semaphore in several drivers
Message-ID: <20070729212909.GC3432@traven>
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

Host AP driver
OnStream SCSI Tape driver
SCSI Tape driver
ISDN subsystem common functions
DVB frontend tuning interface

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

        Representation of the world, like the world itself, is
        the work of men; they describe it from their own point
         of view, which they  confuse with the absolute truth
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
