Return-Path: <linux-kernel-owner+w=401wt.eu-S1761990AbYDPHuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761990AbYDPHuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 03:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYDPHuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 03:50:04 -0400
Received: from aun.it.uu.se ([130.238.12.36]:33471 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYDPHuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 03:50:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18437.44903.306912.321024@harpo.it.uu.se>
Date: Wed, 16 Apr 2008 09:48:55 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, LKML <linux-kernel@vger.kernel.org>,
       Roel Kluin <12o3l@tiscali.nl>, Andreas Schwab <schwab@suse.de>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm: Fix possible off-by-one in walk_pte_range()
In-Reply-To: <8763ujhz4a.fsf_-_@saeurebad.de>
References: <12082680403770-git-send-email-hannes@saeurebad.de>
	<18436.52094.242415.163660@harpo.it.uu.se>
	<8763ujhz4a.fsf_-_@saeurebad.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner writes:
 > From: Johannes Weiner <hannes@saeurebad.de>
 > Subject: [PATCH] mm: Fix possible off-by-one in walk_pte_range()
 > 
 > After the loop in walk_pte_range() pte might point to the first address
 > after the pmd it walks.  The pte_unmap() is then applied to something
 > bad.
 > 
 > Spotted by Roel Kluin and Andreas Schwab.
 > 
 > Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
 > CC: Roel Kluin <12o3l@tiscali.nl>
 > CC: Andreas Schwab <schwab@suse.de>
 > CC: Matt Mackall <mpm@selenic.com>
 > CC: Andrew Morton <akpm@linux-foundation.org>

Thanks, v2 looks much nicer.

Acked-by: Mikael Pettersson <mikpe@it.uu.se>
