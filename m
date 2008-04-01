Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYDAGqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYDAGqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYDAGq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:46:26 -0400
Received: from nn7.de ([85.214.94.156]:56729 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbYDAGq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:46:26 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2008 02:46:25 EDT
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
From: Soeren Sonnenburg <kernel@nn7.de>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20080401062734.GA8824@dose.home.local>
References: <20080320060550.GA13200@dose.home.local>
	 <20080320105432.GA13404@dose.home.local>
	 <20080325231300.GA10641@thinkpad.home.local>
	 <200803290003.16199.rjw@sisk.pl> <20080331212812.GB5313@dose.home.local>
	 <1207030991.11035.35.camel@localhost>
	 <20080401062734.GA8824@dose.home.local>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 01 Apr 2008 06:38:18 +0000
Message-Id: <1207031898.11035.38.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 08:27 +0200, Tino Keitel wrote:
> On Tue, Apr 01, 2008 at 06:23:11 +0000, Soeren Sonnenburg wrote:
> > On Mon, 2008-03-31 at 23:28 +0200, Tino Keitel wrote:
> > > On Sat, Mar 29, 2008 at 00:03:15 +0100, Rafael J. Wysocki wrote:
> > > 
> > > [...]
> > > 
> > > > Can you please try to boot with acpi_new_pts_ordering and retest?
> > > 
> > > I just tried current -git (a9edadbf790d72adf6ebed476cb5caf7743e7e4a),
> > > without success. I still got the same hand at resume.
> > 
> > I am having the hang on resume problem too (macbook pro), cf.
> > http://bugzilla.kernel.org/show_bug.cgi?id=10319, 2.6.24 was fine.
> 
> What about 2.6.25-rc5? Up to this, resume works for me. -rc6 is broken.

No never worked in 2.6.25 (at least from rc2 on) and still does not in
rc7-current-git. But note that on console I could suspend to ram and
resume but the display is not anymore coming back with s2ram - from
within X it freezes though.

Soeren

