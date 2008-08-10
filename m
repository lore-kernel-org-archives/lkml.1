Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYHJKvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYHJKvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 06:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYHJKvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 06:51:13 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48651 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYHJKvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 06:51:12 -0400
Date: Sun, 10 Aug 2008 11:50:33 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Theodore Tso <tytso@mit.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [Bug #11237] [BUG] 2.6.27-rc1 in ext3_find_entry
In-Reply-To: <20080810034359.GA21407@mit.edu>
Message-ID: <Pine.LNX.4.64.0808101142470.10875@blonde.site>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.ZsB.hDjnIB@albercik>
 <20080810034359.GA21407@mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2008, Theodore Tso wrote:
> On Sun, Aug 10, 2008 at 12:43:51AM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).

Yes, it should still be listed.

> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
> > Subject		: [BUG] 2.6.27-rc1 in ext3_find_entry
> > Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > Date		: 2008-08-02 9:51 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
> > Handled-By	: Hugh Dickins <hugh@veritas.com>
> > 
> 
> You might want to change the description to include that it occurred
> after a suspend/resume; Hugh suspects corrupted PMD entries as the
> cause of the crash, and not necessarily anything in the ext3 code.  So
> the title might be a bit misleading.  (At the same time, if turns out
> that the suspend/resume was a red herring, and it looks more like a
> real ext3 bug, please send a note to that effect; right now I'm not
> paying attention to this bug.)

Right, there's no reason at all to suppose it's related to ext3,
that just happened to be the first victim of the corruption on
one occasion.  Carry on paying no attention to this bug, Ted.
"corrupt PMD after resume" perhaps.

Hugh
