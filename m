Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbXDIER4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbXDIER4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 00:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXDIER4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 00:17:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:50510 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752670AbXDIERz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 00:17:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18/9ClWxMk/nP5UtaGZZjtCbk6J3uYW+mlVCV0QjO
	e1KpLtZU6aPY3b
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704081356.48843.gene.heskett@gmail.com>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704080733.39303.gene.heskett@gmail.com>
	 <1176032450.6304.3.camel@Homer.simpson.net>
	 <200704081356.48843.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 06:17:51 +0200
Message-Id: <1176092271.6355.16.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-08 at 13:56 -0400, Gene Heskett wrote:
> On Sunday 08 April 2007, Mike Galbraith wrote:
> >On Sun, 2007-04-08 at 07:33 -0400, Gene Heskett wrote:
> >> That seems to be the killer loading here, building a kernel (make -j3)
> >> doesn't seem to lag it all that bad.  One session of gzip -best makes
> >> it fall plumb over though, which was a disappointment.
> >
> >Can you make a testcase that doesn't require amanda?
> >
> >	-Mike
> 
> Sure.  Try 'tar czf nameofarchive.tar.gz /path/to-dir-to-be-backed-up'
> 
> Or, from the runtar log from this morning, and this is all one line:
> 
> runtar.20070408022016.debug:running: /bin/tar: 'gtar' '--create' '--file' '-' '--directory' '/usr/dlds-rpms' '--one-file-system' '--listed-incremental' '/usr/local/var/amanda/gnutar-lists/coyote_usr_dlds-rpms_1.new' '--sparse' '--ignore-failed-read' '--totals' '--exclude-from' '/tmp/amanda/sendbackup._usr_dlds-rpms.20070408022016.exclude' '.'
> 
> and amanda will if requested, pipe that output through a |gzip -best, and 
> its this process that brings the machine to the table begging for scraps 
> like a puppy.  Tar by itself can be felt but isn't bad.

So tar -cvf - / | gzip --best | tar -tvzf - should reproduce the
problem?

	-Mike

