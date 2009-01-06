Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbZAFTcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbZAFTcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZAFTb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:31:56 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41278
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZAFTb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:31:56 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Theodore Tso <tytso@mit.edu>
Subject: Re: document ext3 requirements
Date: Tue, 6 Jan 2009 13:31:16 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Andi Kleen <andi@firstfloor.org>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Duane Griffin <duaneg@dghda.com>,
       Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <87k5984f4e.fsf@basil.nowhere.org> <20090106155729.GA10034@mit.edu>
In-Reply-To: <20090106155729.GA10034@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061331.18690.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009 09:57:29 Theodore Tso wrote:
> On Tue, Jan 06, 2009 at 04:40:33PM +0100, Andi Kleen wrote:
> > > Well, Kurt Garloff wrote that program years and years ago.  I'm sure
> > > if someone created patches he'd probably accept them, though.  It's
> > > still the best program I've found for doing image backups in
> > > catastrophic situations.
> >
> > Better would be just to incorporate the functionality as an option
> > into standard GNU dd. Then everyone would easily have access to it.
>
> I'm not sure whether the GNU coreutils maintainer would be willing to
> accept a series of Linux-specific interfaces, but dd_rescue also has
> the advantage that it uses a large blocksize for speed, but when an
> error is returned, it backs off to a small block size to recovery the
> maximum amount of data, and then later returns to the large block
> size.  (Ideally, it should be able to query the disk drive to
> determine its internal block size, and use that for the smaller block
> size, but I'm not sure if there's a standardized way that value is
> exposed by HDD's or SDD's.)

I don't suppose there a Documentation file to put data recovery information 
in?

(Maybe the new filesystems expectations file, which doesn't seem the best name 
for it...?)

Rob
