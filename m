Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYHJDoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYHJDoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 23:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYHJDoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 23:44:07 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36433 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753683AbYHJDoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 23:44:05 -0400
Date: Sat, 9 Aug 2008 23:43:59 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [Bug #11237] [BUG] 2.6.27-rc1 in ext3_find_entry
Message-ID: <20080810034359.GA21407@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Hugh Dickins <hugh@veritas.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.ZsB.hDjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX_-nNkxKaF.A.ZsB.hDjnIB@albercik>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:43:51AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
> Subject		: [BUG] 2.6.27-rc1 in ext3_find_entry
> Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date		: 2008-08-02 9:51 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
> Handled-By	: Hugh Dickins <hugh@veritas.com>
> 

You might want to change the description to include that it occurred
after a suspend/resume; Hugh suspects corrupted PMD entries as the
cause of the crash, and not necessarily anything in the ext3 code.  So
the title might be a bit misleading.  (At the same time, if turns out
that the suspend/resume was a red herring, and it looks more like a
real ext3 bug, please send a note to that effect; right now I'm not
paying attention to this bug.)

						- Ted
