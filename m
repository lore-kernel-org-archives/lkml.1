Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZAFPas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZAFPas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbZAFPak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:30:40 -0500
Received: from THUNK.ORG ([69.25.196.29]:48168 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZAFPaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:30:39 -0500
Date: Tue, 6 Jan 2009 10:30:20 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090106153020.GB13086@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Pavel Machek <pavel@suse.cz>, Sitsofe Wheeler <sitsofe@yahoo.com>,
	Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <200901042149.27655.rob@landley.net> <20090105111913.47a8d1a5@lxorguk.ukuu.org.uk> <200901051300.09169.rob@landley.net> <yq1ocyl1rkq.fsf@sermon.lab.mkp.net> <20090106104146.GD6700@merlin.emma.line.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106104146.GD6700@merlin.emma.line.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 11:41:46AM +0100, Matthias Andree wrote:
> > Rob> Good to know, but "my laptop hard drive just died" is not the
> > Rob> optimal time to learn these sorts of things.
> > 
> > http://www.garloff.de/kurt/linux/ddrescue/
> 
> While nice, it does not reconfigure the block layer to reduce retries;
> at least not in a manner I see at a glance; no sysctl or SG_IO or ioctl
> or fcntl anywhere.

Well, Kurt Garloff wrote that program years and years ago.  I'm sure
if someone created patches he'd probably accept them, though.  It's
still the best program I've found for doing image backups in
catastrophic situations.

						- Ted
