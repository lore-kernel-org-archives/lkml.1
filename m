Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZEDR1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZEDR1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZEDR1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:27:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53965 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbZEDR1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:27:32 -0400
Date: Mon, 4 May 2009 13:27:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Olivier Galibert <galibert@pobox.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504172731.GA32651@infradead.org>
References: <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <1241451391.20170.12.camel@norville.austin.ibm.com> <m14ow0hnal.fsf@fess.ebiederm.org> <1241453259.20170.17.camel@norville.austin.ibm.com> <m1k54wal0j.fsf@fess.ebiederm.org> <20090504170636.GA56325@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504170636.GA56325@dspnet.fr.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 07:06:37PM +0200, Olivier Galibert wrote:
> Because knowingly violating a patent triples the damages, among other
> things.
> 
> There's a persistent rumor that a valid microsoft US software patent
> exists that covers the standard method of handling long file names on
> FAT filesystems.  It seems that such a patent is used by microsoft in
> litigations, the latest being against tomtom.  I think all of these
> litigations have been settled, but I can easily be wrong.
> 
> I have no idea whether such a patent actually exists, and even knowing
> the reference (I don't) I am not competent to judge what it covers or
> whether it would actually hold up in court.
> 
> But knowingly violating a patent is consider way worse in US courts
> than simple independant recreation.  So I guess the knowingly part is
> what the "you need a local lawyer" crowd tries to avoid.

And now we get a patch that introduces a configure option above code
dealing with longnames which disables a very specific piece of code.

Because of that let us assume that IBM Corporate, Paul E. McKenney, Andrew
Tridgell and other know what code exactly infridges that patent.  IBM
has worked around that code in the various embedded Linux offerings they
ship and probably urge distributors to disable it.  Why would we not
remove that code unconditionally in that case and let other people
infridge it?

Or that patent is believed to be invalid and faught, and there was
absolute no reason to remove it except for companies doing as part of a
settlement and they could do it in their privat trees.

Or both of the two above variants are wrong.  That's why we do need a
good description of what is actually happening, and I don't feel a
signed-off-by is justified if adds an option that can disable known
infringing code (if that actually is the case) but leaves it otherwise
if fine.  If it's not actually infringing we need an even better
explanation.


