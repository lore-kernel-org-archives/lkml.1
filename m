Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012Ab0AGVA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab0AGVA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316Ab0AGVA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:00:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47877 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab0AGVA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:00:28 -0500
Date: Thu, 7 Jan 2010 21:58:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: mark gross <mgross@linux.intel.com>
Cc: 640E9920 <640e9920@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC] PM_QOS api update to use handles 1/5
Message-ID: <20100107205838.GA23120@elf.ucw.cz>
References: <20091130010953.GA4732@mgross-laptop>
 <20100104083127.GA1450@ucw.cz>
 <20100106191132.GD21316@linux.intel.com>
 <20100106191831.GA3045@elf.ucw.cz>
 <20100107205558.GB5703@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107205558.GB5703@linux.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-01-07 12:55:58, mark gross wrote:
> On Wed, Jan 06, 2010 at 08:18:31PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > > Umm.. passing binary numbers like that... is not exactly good
> > > > interface. Think endianness issues  when writing to it from high-level
> > > > language.
> > > 
> > > yeah.  At the moment I can't recall why I went binary for the ABI, 
> > > we can revisit this, but its been in the wild for a few years now :(
> > > 
> > > I guess I can do some tricks to see if its a hex string representation
> > > of a number and parse that as well as supporting the s32.  i.e. accept
> > > strings "0x0000000" ... "0xFFFFFFFF" and return -EINVAL for anything
> > > else.
> > 
> > Maybe you could use length for detection? If they are writing 4 bytes,
> > it is s32, 10 bytes means ascii?
> 
> That is what I was thinking + making sure the chars in the string where
> valid hex digits ;)  It would be easy to do.  Let me know if you think I
> should attempt to roll that into the kernel ABI exposed by this thing.

I think that would be nice, yes.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
