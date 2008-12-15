Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYLOUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYLOUJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYLOUJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:09:13 -0500
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1779 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYLOUJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:09:12 -0500
Date: Mon, 15 Dec 2008 21:08:05 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Chris Friesen <cfriesen@nortel.com>,
       mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081215200805.GI7083@vanheusden.com>
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu> <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu> <20081215110310.GA10274@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215110310.GA10274@elf.ucw.cz>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Tue Dec 16 16:43:49 CET 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There are certainly things you can do.  Put your fileservers's on
> > UPS's.  Use RAID.  Make backups.   Do all three.  :-)
> 
> Okay, so we pretty much	know that ext3 journalling helps in "user hit
> the reset button" case. (And we are pretty sure ext2/ext3 works in
> "clean unmount" case). Otherwise
> 
> *) kernel bug -> journalling does not help.
> 
> *) sudden powerfail -> journalling helps works on SGI high-end
> hardware. It may or may not help on PC-class hardware.
> 
> We already do periodic checks, even on ext3. Maybe we should do fsck
> more often if we see evidence of unclean shutdowns (because we know
> PC hardware is crap...).

What we might need is on-line fsck. E.g. fsck while the fs is still
mounted.

Might be tricky to implement.



Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
