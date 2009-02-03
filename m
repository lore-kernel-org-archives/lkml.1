Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZBCWZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZBCWZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZBCWZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:25:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36993 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZBCWZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:25:17 -0500
Date: Tue, 3 Feb 2009 23:25:01 +0100
From: Pavel Machek <pavel@suse.cz>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Valdis.Kletnieks@vt.edu, "Eric W. Biederman" <ebiederm@xmission.com>,
       Doug Thompson <norsk5@yahoo.com>, ncunningham-lkml@crca.org.au,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, bluesmoke-devel@lists.sourceforge.net
Subject: Re: marching through all physical memory in software
Message-ID: <20090203222501.GC2857@elf.ucw.cz>
References: <715599.77204.qm@web50111.mail.re2.yahoo.com> <m1wscc7fop.fsf@fess.ebiederm.org> <49873B99.3070405@nortel.com> <37985.1233614746@turing-police.cc.vt.edu> <4988555B.8010408@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4988555B.8010408@nortel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>> The next question is who handles the conversion of the various 
>>> different arch-specific BIOS mappings to a standard format that we 
>>> can feed to the background "scrub" code.  Is this something that 
>>> belongs in the edac memory controller code, or would it live in 
>>> /arch/foo somewhere?
>>
>>
>> If it's intended to be something basically stand-alone that doesn't require
>> an actual EDAC chipset, it should probably live elsewhere.  Otherwise, you get
>> into the case of people who don't enable it because they "know" their hardware
>> doesn't have an EDAC ability, even if they *could* benefit from the function.
>>
>> On the other hand, if it's an EDAC-only thing, maybe under drivers/edac/$ARCH?
>
> I don't see anything in the name of EDAC that implies hardware only...a  
> software memory scrub could be considered "error detection and  
> correction".  Might have to update the config help text though.

Software memory scrub would no longer be a "driver" :-). So it should
go into kernel/scrub or mm/scrub or maybe mm/edac or something.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
