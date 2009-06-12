Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbZFLUGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbZFLUGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 16:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZFLUGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 16:06:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35183 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbZFLUGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 16:06:37 -0400
Date: Fri, 12 Jun 2009 22:06:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Lauro Salmito <laurosalmito@gmail.com>, Magnus Damm <damm@igel.co.jp>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Sergio Luis <sergio@larces.uece.br>
Subject: Re: [GIT PULL] PM updates for 2.6.31
Message-ID: <20090612200633.GB17688@elf.ucw.cz>
References: <200906122202.08345.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906122202.08345.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-06-12 22:02:06, Rafael J. Wysocki wrote:
> Hi Linus,
> 
> Please pull power management updates for 2.6.31 from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus
> 
> They are cleanups and code rearrangements mostly, in particular:
> 
> * arch/x86/power/cpu_(32|64) unification from Sergio Luis (Ingo saw
>   these patches and his opinion was that they should better go
>   through the suspend tree)
> 
> * Removal of some unused files and PM callbacks, function renames
>   from Magnus Damm and Alan Stern
> 
> * Rearrangements of the code under kernel/power from me and
>   Cornelia Huck
> 
> * Two patches related to the memory shrinking (for the record, Pavel
>   doesn't like the "PM/Suspend: Do not shrink memory before suspend"
>   patch, so please let me know if I should drop it)

Thanks.

For the record, the patch will break suspend if suspend is attempted
with 0 pages free. (I believe Rafael agrees with this).

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
