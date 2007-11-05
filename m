Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbXKEKrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbXKEKrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbXKEKrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:47:48 -0500
Received: from ns.suse.de ([195.135.220.2]:43600 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbXKEKrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:47:47 -0500
From: Andreas Schwab <schwab@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       LIOU Payphone <lioupayphone@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Forbid user to change file flags on quota files
References: <20071101155204.GB30523@duck.suse.cz>
	<Pine.LNX.4.64.0711021831340.26618@fbirervta.pbzchgretzou.qr>
	<20071105103230.GA9561@duck.suse.cz>
X-Yow: It's NO USE..  I've gone to ``CLUB MED''!!
Date: Mon, 05 Nov 2007 11:47:01 +0100
In-Reply-To: <20071105103230.GA9561@duck.suse.cz> (Jan Kara's message of "Mon\,
	5 Nov 2007 11\:32\:30 +0100")
Message-ID: <jefxzlas0q.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Fri 02-11-07 18:32:08, Jan Engelhardt wrote:
>> 
>> On Nov 1 2007 16:52, Jan Kara wrote:
>> 
>> >--- linux-2.6.24-rc1/fs/ext2/ioctl.c	2007-10-24 20:43:56.000000000 +0200
>> >+++ linux-2.6.24-rc1-1-forbid_setflags/fs/ext2/ioctl.c	2007-11-01 16:01:26.000000000 +0100
>> >@@ -47,6 +47,11 @@ int ext2_ioctl (struct inode * inode, st
>> > 			flags &= ~EXT2_DIRSYNC_FL;
>> > 
>> > 		mutex_lock(&inode->i_mutex);
>> >+		/* Is it quota file? Don't allow user mess with it */
>> 
>> "Do not allow user to mess with it".
>   I think both "allow user mess" and "allow user to mess" are possible,

I think it's either "to allow doing sth" or "to allow to do sth", but
"to allow do sth" looks definitely wrong to me.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
