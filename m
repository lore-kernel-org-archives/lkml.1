Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYFWH6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYFWH6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYFWH6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:58:10 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:43269 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751931AbYFWH6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:58:09 -0400
Date: Mon, 23 Jun 2008 09:58:00 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: Miquel van Smoorenburg <mikevs@xs4all.net>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080623075800.GA2379@anita>
Mail-Followup-To: Miquel van Smoorenburg <mikevs@xs4all.net>,
	Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	xfs-masters@oss.sgi.com
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <1213309629.29745.8.camel@localhost.localdomain> <20080613030841.GC3700@disturbed> <20080620052716.GA2022@anita> <20080622225355.GD11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622225355.GD11558@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-06-23 08:53 +1000 schrieb Dave Chinner:

> > If I am correct, this fix is included in 2.6.26-rc6:
> 
> Yes, so if you're seeing it again then there's a different problem.

There seems to be something else too, yes.

> Please provide a pointer to a xfs_metadump image of the filesystem
> and the steps to reproduce the error from the image so we can
> get to the bottom of it...

Well, accidently I formatted the partition. I needed my /var partition
urgently and I tried the following: I tarred the whole /var from a
rescue system (gentoo amd64 live cd version 2007.0, IIRC there is 2.6.19
on it) and did a "rm -fr /var/*" and tried to tar it back.

While this worked for my /home (I also had the error there), tarring
back the files onto /var produced several oopses in dmesg and the
userspace complained about an error in a (directory?) structure not
being accessible/not able to be initialized. Well, I took screenshots of
this but accidently I lost them on my cam and due to running a rescue
system there is no reminisence in a file of this. 

I formatted the partition then :-(

I could only try to reproduce it on my home partition... Does anybody
have a clue how this can be done or a suspicion how to trigger this
error?

King Regards, Konsti


-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
