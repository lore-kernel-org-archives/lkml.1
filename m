Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbZKXMC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbZKXMC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 07:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbZKXMCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 07:02:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55233 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbZKXMCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 07:02:24 -0500
Date: Tue, 24 Nov 2009 12:43:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: scjody@sun.com
Cc: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
Subject: Re: [patch 0/5] Journal guided resync and support
Message-ID: <20091124114319.GA1397@ucw.cz>
References: <20091119212241.283629302@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119212241.283629302@sun.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is an updated implementation of journal guided resync, intended to be
> suitable for production systems.  This feature addresses the problem with RAID
> arrays that take too long to resync - similar to the existing MD write-intent
> bitmap feature, we resync only the stripes that were undergoing writes at the
> time of the crash.  Unlike write-intent bitmaps, our testing shows very little
> performance degredation as a result of the feature - around 3-5% vs around 30%
> for bitmaps.

Good. Now when fs know about raid and wise versa... perhaps it is time
to journal surrounding data on stripe so that power fails do not
destroy data on degraded raid5?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
