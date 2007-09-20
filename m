Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbXITKm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbXITKm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 06:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXITKmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 06:42:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57772 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXITKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 06:42:50 -0400
Date: Thu, 20 Sep 2007 12:42:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kdump detection in SCSI drivers
Message-ID: <20070920104249.GB12157@atrey.karlin.mff.cuni.cz>
References: <9738BCBE884FDB42801FAD8A7769C26501B2C44C@NAMAIL1.ad.lsil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501B2C44C@NAMAIL1.ad.lsil.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> Is there a standard way for drivers (RAID) to detect if the current
> kernel is running in kdump mode? We would like to adjust driver behavior
> dynamically when kdump is active by scaling down resources.

Perhaps you should be automatically using little resources when little
memory is available, or something? 

With upcomping kjump patches, it is more "interesting" than kdump
vs. no kdump.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
