Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYEKRps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYEKRps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYEKRpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:45:39 -0400
Received: from mx1.riseup.net ([204.13.164.18]:41494 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbYEKRpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:45:38 -0400
Message-Id: <20080511174331.584439618@kaehlcke.net>
User-Agent: quilt/0.46-1
Date: Sun, 11 May 2008 19:43:31 +0200
From: matthias@kaehlcke.net
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 0/2] HFS: Convert bitmap_lock and extents_lock in mutexes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apple Macintosh file system: The semaphores bitmap_lock and extents_lock are used as mutexes. Convert them to the mutex API

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
