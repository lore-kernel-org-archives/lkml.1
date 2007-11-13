Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbXKMRtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbXKMRtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757268AbXKMRtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:49:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55081 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbXKMRtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:49:08 -0500
Date: Tue, 13 Nov 2007 18:49:07 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Natalie Protasevich <protasnb@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-input@atrey.karlin.mff.cuni.cz, bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113174907.GB13733@atrey.karlin.mff.cuni.cz>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > FILE SYSTEMS=======================================================
> > 
> > ext4: delalloc space accounting problem drops data
> > http://bugzilla.kernel.org/show_bug.cgi?id=9329
> > Kernel: 2.6.24-rc1
> No response from developers
  Actually, there has been a response (Eric asked in mailing list and
created a bug and got answer to the mailing list):
http://marc.info/?l=linux-ext4&m=119454449014728&w=2

> > POSIX Access Control Lists cause bogus file system check errors
> > http://bugzilla.kernel.org/show_bug.cgi?id=9241
> > Kernel: 2.6.23.1
> 
> Andreas did some work, seemed to lose interest.
  As I read the bug it seems that the cause was a filesystem with errors
(which were in ACL's and thus kernel didn't boot only with ACL's
enabled) and fsck fixed the problem... I would close this one as
invalid (OK, I know the filesystem had to be corrupted somehow but
unless this is at least occasionally reproducible, there's low chance of
finding the bug).

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
