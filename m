Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbYDKLtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbYDKLtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbYDKLsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:48:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33897 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759812AbYDKLsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:48:37 -0400
Date: Fri, 11 Apr 2008 13:49:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: matthltc@us.ibm.com, linux-pm@lists.linux-foundation.org
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFC PATCH 0/4] Container Freezer: Reuse Suspend Freezer
Message-ID: <20080411114921.GA1740@elf.ucw.cz>
References: <20080403210316.397506379@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403210316.397506379@us.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> NOTE: Due to problems with my MTA configuration two earlier attempts reached linux-pm
> but not linux-kernel. Please cc linux-pm@lists.linux-foundation.org on replies.
> 
> This patchset is a prototype using the container infrastructure and
> the swsusp freezer to freeze a group of tasks. I've merely taken Cedric's
> patches, forward-ported them to 2.6.25-rc8-mm1 and done a small amount of
> testing.

Okay, freezer probably does what you want, but be warned that Linus is
not exactly in love with freezer. You probably can get away with using
it for user processes, but maybe you should drop him the line saying
you want to expand freezer usage and see what happens.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
