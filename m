Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZA0JP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZA0JP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 04:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZA0JPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 04:15:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53395 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbZA0JPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 04:15:34 -0500
Date: Tue, 27 Jan 2009 10:15:33 +0100
From: Pavel Machek <pavel@suse.cz>
To: marty <martyleisner@yahoo.com>
Cc: "Leisner, Martin" <Martin.Leisner@xerox.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: FW: [linux-pm] select with timeout across S3
Message-ID: <20090127091533.GC8543@atrey.karlin.mff.cuni.cz>
References: <20080911092408.GA14503@elf.ucw.cz> <739522.18279.qm@web50606.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <739522.18279.qm@web50606.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't see a behavior change in the current kernels.
> 
> Select(2) timeouts only count the time the machine is up -- not sleeping...
> 
> I had a patch for 2.6.20 that I tried (it modified schedule_timeout) -- 
> it didn't do anything useful in 2.6.27-rc5.

Do you have some code to demonstrate that? We may want to fix this one
some day...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
