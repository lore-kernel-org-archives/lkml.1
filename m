Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbYKORSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbYKORSC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:18:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYKORRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:17:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35339 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751613AbYKORRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:17:52 -0500
Date: Sat, 15 Nov 2008 18:17:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: Len Brown <lenb@kernel.org>
Cc: stable@kernel.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [STABLE PATCH .26 .27] ACPI: avoid empty file name in sysfs
Message-ID: <20081115171725.GB1523@ucw.cz>
References: <alpine.LFD.2.00.0811130015100.3128@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811130015100.3128@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> upstream 4feba70a2c1a1a0c96909f657f48b2e11e682370
> 
> Since commit bc45b1d39a925b56796bebf8a397a0491489d85c acpi tables are
> allowed to have an empty signature and /sys/firmware/acpi/tables uses the
> signature as filename.  Applications using naive recursion through /sys
> loop forever.  A possible solution would be: (replacing the zero length
> filename with the string "NULL")

What about using some string that is not a valid table name? Shorter
than 4 characters? AFAICT,
'NULL' table could be added to acpi in future...?

What if *two* tales have empty signature?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
