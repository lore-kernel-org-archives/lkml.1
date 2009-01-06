Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZAFKmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZAFKmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbZAFKlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:41:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:39550 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750738AbZAFKly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:41:54 -0500
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX18XSWJiDzAXfWpqKbhvsgIsLX4GT+RF76OoUCsvZA
	xKVclBHwfkzDyl
Date: Tue, 6 Jan 2009 11:41:46 +0100
From: Matthias Andree <matthias.andree@gmx.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Duane Griffin <duaneg@dghda.com>,
       Valdis.Kletnieks@vt.edu,
       Martin =?iso-8859-15?Q?MOKREJ=A6?= 
	<mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090106104146.GD6700@merlin.emma.line.org>
Mail-Followup-To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
	Martin =?iso-8859-15?Q?MOKREJ=A6?= <mmokrejs@ribosome.natur.cuni.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <200901042149.27655.rob@landley.net> <20090105111913.47a8d1a5@lxorguk.ukuu.org.uk> <200901051300.09169.rob@landley.net> <yq1ocyl1rkq.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1ocyl1rkq.fsf@sermon.lab.mkp.net>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009, Martin K. Petersen wrote:

> >>>>> "Rob" == Rob Landley <rob@landley.net> writes:
> 
> Rob> On Monday 05 January 2009 05:19:13 Alan Cox wrote:
> >> You could of course just learn to use the functions the kernel
> >> provides.  If you want to recover disk blocks without retrying you
> >> can do that via SG_IO. If you want to adjust the timeout and retry
> >> levels you can do that too via sysfs.
> 
> Rob> Good to know, but "my laptop hard drive just died" is not the
> Rob> optimal time to learn these sorts of things.
> 
> http://www.garloff.de/kurt/linux/ddrescue/

While nice, it does not reconfigure the block layer to reduce retries;
at least not in a manner I see at a glance; no sysctl or SG_IO or ioctl
or fcntl anywhere.

-- 
Matthias Andree
