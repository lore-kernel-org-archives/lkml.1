Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZD0WHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZD0WHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZD0WHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:07:09 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:51132 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZD0WHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:07:07 -0400
Date: Mon, 27 Apr 2009 23:07:02 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, DRI <dri-devel@lists.sourceforge.net>,
       Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Subject: Re: [Bug #12765] i915 VT switch with AIGLX causes X lock up
Message-ID: <20090427220702.GA31679@sucs.org>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.X4D.-qE9JB@chimera> <20090427094651.7cc09227@hobbes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427094651.7cc09227@hobbes>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 09:46:51AM -0700, Jesse Barnes wrote:
> On Sun, 26 Apr 2009 11:46:26 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still
> > should be listed and let me know (either way).

The problem is still here in 2.6.29-rc3.

> I think we had a workaround for this (attached), but it sounds like
> Robert has tracked down the root cause (search for "Broken vblanks on
> Intel" on dri-devel@lists.sourceforge.net).  Will try to get the fix

http://www.mail-archive.com/dri-devel@lists.sourceforge.net/msg39370.html
seems to be it.

> into the Intel driver soon.  Fortunately this doesn't seem to be biting
> a lot of people (at least not that I've heard); I certainly have a hard
> time reproducing it.

The patch that was attached to Jesse's mail seems to resolve the
problem...

-- 
Sitsofe | http://sucs.org/~sits/
