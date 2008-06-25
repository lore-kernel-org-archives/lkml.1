Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYFYJDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYFYJDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYFYJC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:02:56 -0400
Received: from [160.80.85.134] ([160.80.85.134]:59499 "HELO
	smeagol.sprg.uniroma2.it" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with SMTP id S1753890AbYFYJCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:02:55 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 05:02:54 EDT
Date: Wed, 25 Jun 2008 10:56:12 +0200
From: Marco Cesati <cesati@uniroma2.it>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Jackson <pj@sgi.com>, hpa@zytor.com, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
Message-Id: <20080625105612.55fde5f0.cesati@uniroma2.it>
Reply-To: cesati@uniroma2.it
Organization: DISP - University of Rome Tor Vergata
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.13; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008, Linus Torvalds wrote:
> > I'd be inclined instead to use "%P" for symbolic addrs.
> That doesn't work - gcc warns about it.
> 
> That turns out to be a problem with %#p too. 

I believe that using "%-p" instead of "%#p" would work.
The canonical meaning of "%-p" should be the very same as 
"%p", but gcc should not complain because it is
ready to parse a format string like "%-10p" (which is of
course different than "%10p").

A bit too tricky, perhaps?!

Tested on gcc 4.1.2.

	Marco

-- 
Marco Cesati <cesati@uniroma2.it>
Universita' degli Studi di Roma Tor Vergata - DISP
via del Politecnico 1, 00133 Roma
