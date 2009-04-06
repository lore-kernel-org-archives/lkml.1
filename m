Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbZDFSqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbZDFSqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757717AbZDFSp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:45:57 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:17494 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705AbZDFSp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:45:56 -0400
Date: Mon, 6 Apr 2009 20:47:18 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andrey Borzenkov <arvidjaar@gmail.com>,
       Andrea Righi <righi.andrea@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: commit 66c1ca breaks fbdev mode switching
Message-Id: <20090406204718.ce4909b3.krzysztof.h1@poczta.fm>
In-Reply-To: <20090322145219.ad294615.akpm@linux-foundation.org>
References: <498817E2.3020008@gmail.com>
	<1233783983-28802-1-git-send-email-righi.andrea@gmail.com>
	<200903221748.42871.arvidjaar@gmail.com>
	<200903221857.20473.rjw@sisk.pl>
	<20090322145219.ad294615.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 92e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The commit 66c1ca breaks fbdev mode switching. The first mode
(selected with mode_option or during boot) is ok but every mode
switch with fbset locks up computer. If the commit is reverted
mode switching works correctly.

I do not understand why. I would be grateful if someone else
can confirm the problem as well.

The commit's details are:

commit 66c1ca019078220dc1bf968f2bb18421100ef147
Author: Andrea Righi <righi.andrea@gmail.com>
Date:   Tue Mar 31 15:25:18 2009 -0700

    fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency
    

Regards,
Krzysztof

----------------------------------------------------------------------
Kto lepiej radzi sobie w kuchni?
Odpowiedz i wygraj sprzet AGD! >> http://link.interia.pl/f2103 

