Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZCQNHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZCQNHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZCQNHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:07:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45955 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbZCQNHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:07:05 -0400
Date: Sat, 14 Mar 2009 17:13:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Christopher Brannon <cmbrannon@cox.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
Message-ID: <20090314161341.GB1496@ucw.cz>
References: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-03-11 10:10:23, Christopher Brannon wrote:
> Under Plan 9 from Bell Labs, one queries or sets the system clock by
> reading or writing text strings to a special file named /dev/time.
> I implemented such a facility for Linux.  A read of /dev/time produces
> four decimal numbers: epoch seconds, nanoseconds since start of epoch,
> nanoseconds since boot, and nanoseconds per second.  Writing a
> decimal number

nanoseconds per second?! Just use 123.456 notation.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
