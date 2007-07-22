Return-Path: <linux-kernel-owner+w=401wt.eu-S1761898AbXGVSk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898AbXGVSk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbXGVSkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:40:19 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:41834
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759016AbXGVSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:40:18 -0400
Date: Sun, 22 Jul 2007 20:42:02 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Use list_for_each_entry(_safe) instead of list_for_each(_safe)
Message-ID: <20070722184202.GF27415@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset converts list_for_each(_safe) to
list_for_each_entry(_safe) in the following files:

kernel/exit.c
kernel/time/clocksource.c
kernel/user.c
mm/oom_kill.c
mm/page_alloc.c
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      El trabajo es el refugio de los que no tienen nada que hacer
                            (Oscar Wilde)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
