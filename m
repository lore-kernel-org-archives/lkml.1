Return-Path: <linux-kernel-owner+w=401wt.eu-S933557AbZDBATU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbZDBATU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbZDBATB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:19:01 -0400
Received: from www.tglx.de ([62.245.132.106]:32850 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758103AbZDBATA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:19:00 -0400
Date: Thu, 2 Apr 2009 02:17:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: [Announce] 2.6.29-rt2
In-Reply-To: <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain> <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain> <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain> <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain> <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.
 
      - fix a fork/exit bug in the signal per task cache (/me puts on
        a huge brown paper bag - Thanks to Phillipe Reynes and Will
        Schmidt for reporting and testing)

      - fix a group scheduling migration accounting bug (decoded with
        and fixed by Peter Zijlstra - reported by Robin Gareus)

      - tlb gather rework by Peter Zijlstra - Thanks Peter !

      - the usual fixlets

The tlb rework might be incomplete on some of the uncountable
incarnations of PowerPC and ARM platforms, so look out for wreckage
and keep the usual tools (fire-extinguishers, brooms, buckets etc.)
handy.

Download locations:

    http://rt.et.redhat.com/download/
    http://www.kernel.org/pub/linux/kernel/projects/rt/
 
Information on the RT patch can be found at:

    http://rt.wiki.kernel.org/index.php/Main_Page

to build the 2.6.29-rt2 tree, the following patches should be
applied:

    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.tar.bz2
    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rt2.bz2

The broken out patches are also available at the same download
locations.

Enjoy !

       tglx

