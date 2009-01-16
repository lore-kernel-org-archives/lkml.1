Return-Path: <linux-kernel-owner+w=401wt.eu-S935087AbZAPN7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935087AbZAPN7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934126AbZAPN7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:59:18 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3790 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738AbZAPN7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:59:15 -0500
Date: Fri, 16 Jan 2009 14:57:49 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-ID: <20090116135748.GF29002@vanheusden.com>
References: <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu> <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org> <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain> <20090115180844.GL22472@elte.hu> <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain> <1232047618.8269.93.camel@think.oraclecorp.com> <20090116133203.GE29002@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090116133203.GE29002@vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Fri Jan 16 21:27:58 CET 2009
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'll kick off some runs of my three benchmarks on ext3 for comparison.
> > If there are things less synthetic people would like to see, please let
> > me know.
> 
> What about a web-server test? Number of hits per second it can do?

Quick hack: http://vanheusden.com/tortureweb/tortureweb-0.1.tgz
To test multiple requesters, start this program multiple times in
parallel.
There are probably better testers but for a quick test and might be
sufficient.


Folkert van Heusden

-- 
Multitail es una herramienta flexible que permite visualizar los "log
file" y seguir la ejecución de comandos. Permite filtrar, añadir
colores, combinar archivos, la visualización de diferencias (diff-
view), etc.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
