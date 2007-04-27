Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbXD0IgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbXD0IgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbXD0IgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:36:10 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:56179
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755466AbXD0IgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:36:08 -0400
Date: Fri, 27 Apr 2007 10:38:57 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/5] use mutex instead of semaphore in several drivers
Message-ID: <20070427083857.GB4213@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this patchset converts semaphores that are used as mutexes to the
mutex API in the following drivers/code:

Power Management
Kcopyd
sysdev
pvrusb2
scx200

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

               For to be free is not merely to cast off
               one's chains, but to live in a way that
              respects and enhances the freedom of others
                           (Nelson Mandela)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
