Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZA3I5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZA3I5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZA3I5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:57:31 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43343 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZA3I5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:57:30 -0500
Date: Wed, 28 Jan 2009 20:38:13 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Doug Thompson <norsk5@yahoo.com>, linux-mm@kvack.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: marching through all physical memory in software
Message-ID: <20090128193813.GD1222@ucw.cz>
References: <497DD8E5.1040305@nortel.com> <20090126075957.69b64a2e@infradead.org> <497F5289.404@nortel.com> <m1vds0bj2j.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vds0bj2j.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-27 12:16:52, Eric W. Biederman wrote:
> "Chris Friesen" <cfriesen@nortel.com> writes:
> 
> > Arjan van de Ven wrote:
> >> On Mon, 26 Jan 2009 09:38:13 -0600
> >> "Chris Friesen" <cfriesen@nortel.com> wrote:
> >>
> >>> Someone is asking me about the feasability of "scrubbing" system
> >>> memory by accessing each page and handling the ECC faults.
> >>>
> >>
> >> Hi,
> >>
> >> I would suggest that you look at the "edac" subsystem, which tries to
> >> do exactly this....
> 
> 
> > edac appears to currently be able to scrub the specific page where the fault
> > occurred.  This is a useful building block, but doesn't provide the ability to
> > march through all of physical memory.
> 
> Well that is the tricky part.  The rest is simply finding which physical
> addresses are valid.  Either by querying the memory controller or looking
> at the range the BIOS gave us.
> 
> That part should not be too hard.  I think it simply has not been implemented
> yet as most ECC chipsets implement this in hardware today.

You can do the scrubbing today by echo reboot > /sys/power/disk; echo
disk > /sys/power/state :-)... or using uswsusp APIs.

Take a look at hibernation code for 'walk all memory' examples...  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
