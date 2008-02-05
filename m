Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbYBEMzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbYBEMzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 07:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYBEMzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:55:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52280 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbYBEMzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:55:11 -0500
Date: Tue, 5 Feb 2008 13:54:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [regression] Re: brk randomization breaks columns
Message-ID: <20080205125426.GA27724@elte.hu>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <20080205110632.GB3758@elf.ucw.cz> <Pine.LNX.4.64.0802051216340.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802051216340.30955@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 5 Feb 2008, Pavel Machek wrote:
> 
> > > Actually, this clearly shows that either prehistoric libc.so.5 or the 
> > > program itself are broken.
> > I believe it shows clear regression in latest 2.6.25 kernel.
> 
> I am still not completely sure. It might be a regression, but it also 
> might just trigger the bug in ancient version in libc.so.5 which might 
> be fixed in some later version [...]

which too is a regression ...

really, lets add a sysctl for this, and a .config option that either 
disables or enables it. Then we will default to disabled. (but users can 
enable it - and distros can build their kernels with this .config option 
enabled)

	Ingo
