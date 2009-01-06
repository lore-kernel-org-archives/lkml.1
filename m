Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZAFPkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZAFPkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZAFPki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:40:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51783 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZAFPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:40:37 -0500
To: Theodore Tso <tytso@mit.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
From: Andi Kleen <andi@firstfloor.org>
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no>
	<200901042149.27655.rob@landley.net>
	<20090105111913.47a8d1a5@lxorguk.ukuu.org.uk>
	<200901051300.09169.rob@landley.net>
	<yq1ocyl1rkq.fsf@sermon.lab.mkp.net>
	<20090106104146.GD6700@merlin.emma.line.org>
	<20090106153020.GB13086__11022.1833143898$1231255950$gmane$org@mit.edu>
Date: Tue, 06 Jan 2009 16:40:33 +0100
In-Reply-To: <20090106153020.GB13086__11022.1833143898$1231255950$gmane$org@mit.edu> (Theodore Tso's message of "Tue, 6 Jan 2009 10:30:20 -0500")
Message-ID: <87k5984f4e.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> On Tue, Jan 06, 2009 at 11:41:46AM +0100, Matthias Andree wrote:
>> > Rob> Good to know, but "my laptop hard drive just died" is not the
>> > Rob> optimal time to learn these sorts of things.
>> > 
>> > http://www.garloff.de/kurt/linux/ddrescue/
>> 
>> While nice, it does not reconfigure the block layer to reduce retries;
>> at least not in a manner I see at a glance; no sysctl or SG_IO or ioctl
>> or fcntl anywhere.
>
> Well, Kurt Garloff wrote that program years and years ago.  I'm sure
> if someone created patches he'd probably accept them, though.  It's
> still the best program I've found for doing image backups in
> catastrophic situations.

Better would be just to incorporate the functionality as an option
into standard GNU dd. Then everyone would easily have access to it.

-Andi

-- 
ak@linux.intel.com
