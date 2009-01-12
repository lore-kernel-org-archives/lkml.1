Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZALOPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZALOPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZALOPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:15:44 -0500
Received: from thunk.org ([69.25.196.29]:39955 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbZALOPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:15:44 -0500
Date: Mon, 12 Jan 2009 09:15:39 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mike Snitzer <snitzer@gmail.com>
Cc: Alex Buell <alex.buell@munted.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: Online ext4 defragmention
Message-ID: <20090112141539.GD21793@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mike Snitzer <snitzer@gmail.com>,
	Alex Buell <alex.buell@munted.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <20090111134443.581cfc83@lithium.local.net> <20090111202838.GA29383@mit.edu> <170fa0d20901120539w4e3bbc03na39f01edde206d25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170fa0d20901120539w4e3bbc03na39f01edde206d25@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 08:39:33AM -0500, Mike Snitzer wrote:
> 
> Hi Ted,
> 
> Could you elaborate on which allocation patches you're referring to in
> the ext4 patch queue (2.6.28-ext4-3?) ?

They haven't been implemented yet.  They've been discussed on the ext4
mailing list, however.  Basically, the Orlov algorithm was disabled
for flex_bg, and I want to optimize how directory blocks are allocated
to hopefully speed up fsck times a tad bit more.  The design has been
roughly worked out; but it's a matter of me finding time to code and
test it...

						- Ted
