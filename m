Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZC0Ljw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZC0Ljw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbZC0Lja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:39:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47442 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbZC0Lj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:39:29 -0400
Date: Fri, 27 Mar 2009 12:42:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bodo Eggert <7eggert@gmx.de>
Cc: James Morris <jmorris@namei.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: TOMOYO in linux-next
Message-ID: <20090327114224.GF2585@elf.ucw.cz>
References: <ck5CF-5mU-11@gated-at.bofh.it> <E1Ln8MC-0001RR-1E@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ln8MC-0001RR-1E@be1.7eggert.dyndns.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-03-27 10:28:07, Bodo Eggert wrote:
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > I don't think merging that is good idea. Security should be doable
> > without making shell-like glob matching...
> 
> How do you suppose a security system should handle mozilla modifying
> ~/.bashrc differently from downloading something to ~/pr0n.jpg?

How does shell-like glob matching help there? You'd need to parse
/etc/passwd to find all ~ directories...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
