Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYEZKRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYEZKRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYEZKR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:17:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60177 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbYEZKR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:17:26 -0400
Date: Mon, 26 May 2008 06:16:46 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080526101646.GD24507@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Arjan van de Ven <arjan@linux.intel.com>, Jan Kara <jack@suse.cz>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <4836EE8C.1010200@linux.intel.com> <20080524222304.GD20563@atrey.karlin.mff.cuni.cz> <20080524153020.1df96cf2@linux.intel.com> <20080524224554.GA5970@mit.edu> <20080526093913.GG13529@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526093913.GG13529@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 11:39:13AM +0200, Ingo Molnar wrote:
> Exactly why is pulling an USB stick considered "stupid"? Last i checked 
> there was no physical lock preventing users from doing that.
> 
> Sure, pulling a mounted USB stick is inconvenient ... for _us_ kernel 
> developers. But the user really doesnt care and shouldnt care.

Because they could lose data?  Because if the kernel wakes up and
tries writing to the USB stick right as they pull it out, it could
physically damage the flash format?  I know, stupid reason...  :-)

I know, I know, it's an issue.  If someone wants to look at it, great.
It is on my todo list, but I've been doing a lot of travelling, and
when you have only one laptop, and pulling USB sticks isn't the sort
of thing you can do using UML or KVM, it tends to fall to the bottom
of your list.

							- Ted
