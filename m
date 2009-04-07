Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZDGGLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZDGGLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZDGGLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:11:44 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:38082 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZDGGLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:11:44 -0400
Date: 07 Apr 2009 08:11:36 +0200
From: krzysztof.h1@poczta.fm
Subject: =?UTF-8?q?Re:_Re:_commit_66c1ca_breaks_fbdev_mode_switching?=
To: Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-ORIGINATE-IP: 83.17.101.58
IMPORTANCE: Normal
X-MSMAIL-PRIORITY: Normal
X-PRIORITY: 3
X-Mailer: PSE3
Message-Id: <20090407061136.E94711BAC63@f42.poczta.interia.pl>
X-EMID: d140acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi napisa³(a):
> On Mon, Apr 06, 2009 at 08:47:18PM +0200, Krzysztof Helt wrote:
> > Hi,
> > 
> > The commit 66c1ca breaks fbdev mode switching. The first mode
> > (selected with mode_option or during boot) is ok but every mode
> > switch with fbset locks up computer. If the commit is reverted
> > mode switching works correctly.
> > 
> > I do not understand why. I would be grateful if someone else
> > can confirm the problem as well.
> > 
> > The commit&#039;s details are:
> > 
> > commit 66c1ca019078220dc1bf968f2bb18421100ef147
> > Author: Andrea Righi >righi.andrea@gmail.com>
> > Date:   Tue Mar 31 15:25:18 2009 -0700
> > 
> >     fbmem: fix fb_info->lock and mm->mmap_sem circular locking
> dependency
> >     
> > 
> > Regards,
> > Krzysztof
> 
> Any lockdep info or oops? it just locks up the system?
> 

It just locked up. I can try with more debug info enabled.

Regards,
Krzysztof

----------------------------------------------------------------------
10% zysku na lokacie bankowej z gwarancja BFG. Sprawdz!
http://link.interia.pl/f20fd

