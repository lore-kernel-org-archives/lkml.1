Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127Ab0AFTSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0AFTSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777Ab0AFTSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:18:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43228 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab0AFTSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:18:38 -0500
Date: Wed, 6 Jan 2010 20:18:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: mark gross <mgross@linux.intel.com>
Cc: 640E9920 <640e9920@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC] PM_QOS api update to use handles 1/5
Message-ID: <20100106191831.GA3045@elf.ucw.cz>
References: <20091130010953.GA4732@mgross-laptop>
 <20100104083127.GA1450@ucw.cz>
 <20100106191132.GD21316@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106191132.GD21316@linux.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Umm.. passing binary numbers like that... is not exactly good
> > interface. Think endianness issues  when writing to it from high-level
> > language.
> 
> yeah.  At the moment I can't recall why I went binary for the ABI, 
> we can revisit this, but its been in the wild for a few years now :(
> 
> I guess I can do some tricks to see if its a hex string representation
> of a number and parse that as well as supporting the s32.  i.e. accept
> strings "0x0000000" ... "0xFFFFFFFF" and return -EINVAL for anything
> else.

Maybe you could use length for detection? If they are writing 4 bytes,
it is s32, 10 bytes means ascii?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
