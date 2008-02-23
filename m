Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbYBWUe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbYBWUe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbYBWUeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:34:19 -0500
Received: from daimi.au.dk ([130.225.16.1]:47850 "EHLO daimi.au.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbYBWUeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:34:18 -0500
X-Greylist: delayed 1078 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2008 15:34:18 EST
To: John Levon <levon@movementarian.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	<20080223001130.d8922136.akpm@linux-foundation.org>
	<20080223113724.GB31304@elte.hu>
	<20080223135335.GA28464@totally.trollied.org.uk>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 23 Feb 2008 21:15:52 +0100
In-Reply-To: <20080223135335.GA28464@totally.trollied.org.uk>
Message-ID: <ye8ejb3e8ef.fsf@camel10.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Levon <levon@movementarian.org> writes:

> Soren wrote sysprof when he tried an earlier version of oprofile and
> found it slightly non-obvious. Instead of doing any of these things:

This is not accurate. Sysprof started by me adding a hierarchical call
view to speedprof, a SIGPROF profiler which was basically a hack in
memprof.

Oprofile did not work on my system at the time (Red Hat 9, I believe),
and the website said that I had to apply a patch to the kernel and
recompile, so I didn't try it.

The hierarchical call view in speedprof worked out so well that I
wrote a simple kernel module to produce system-wide stacktraces, and
fed them into speedprof. Since speedprof was just a hack in memprof, I
wrote a new GUI, and sysprof was born.

It was only later I tried oprofile and found it not only much more
difficult to use, but also much less useful when I did get it to work.


Soren
