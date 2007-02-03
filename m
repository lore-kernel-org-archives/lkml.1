Return-Path: <linux-kernel-owner+w=401wt.eu-S1946482AbXBCQTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946482AbXBCQTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 11:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946457AbXBCQTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 11:19:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56186 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946481AbXBCQTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 11:19:12 -0500
Date: Sat, 3 Feb 2007 17:19:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: akuster@mvista.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-ID: <20070203161900.GA4572@elf.ucw.cz>
References: <20070202235132.EDBDF1C448@hermes.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202235132.EDBDF1C448@hermes.mvista.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This adds the ability for the file system to remounted as read only during a
> system suspend.  Log the mount points so when the resume occurs, they can be 
> remounted back to their original states. This is so in an advent of a power
> failure, we try our best to keep data from being corrupted or lost.

We already have sys_sync() hidden in suspend process. So user data
should be safe.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
