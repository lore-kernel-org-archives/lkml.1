Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYFWIZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYFWIZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYFWIYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:24:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48669 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbYFWIYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:24:55 -0400
Date: Mon, 23 Jun 2008 10:24:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Romano Giannetti <romano.giannetti@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       bugme-daemon <bugme-daemon@bugzilla.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10892] Sometime (often) X come out blank (black
	screen)on cold boot - Intel chipset
Message-ID: <20080623082431.GA6918@elte.hu>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <4mRZUF-hVeG.A.BxE._tpXIB@albercik> <1214208550.21984.1.camel@pern>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214208550.21984.1.camel@pern>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Romano Giannetti <romano.giannetti@gmail.com> wrote:

> On Sun, 2008-06-22 at 19:54 +0200, Rafael J. Wysocki wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10892
> > Subject		: Sometime (often) X come out blank (black screen) on cold boot - Intel chipset
> > Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
> > Date		: 2008-06-10 05:33 (13 days old)
> > References	: http://lkml.org/lkml/2008/6/10/137
> 
> I tried to reproduce it this morning with 2.6.26-rc7, but failed. So, 
> it seems gone (but this was an Eisenbug, so I am not certain).

there were a number of drivers/char/drm/ and drivers/char/agp/ fixes 
merged into -rc7 which could have resolved this. Please keep an eye on 
it nevertheless.

	Ingo
