Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZLYTS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZLYTS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 14:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZLYTS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 14:18:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53298 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZLYTS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 14:18:56 -0500
Date: Fri, 25 Dec 2009 20:18:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
       dave.mccracken@oracle.com, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, chris.mason@oracle.com,
       linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Tmem [PATCH 0/5] (Take 3): Transcendent memory
Message-ID: <20091225191848.GB8438@elf.ucw.cz>
References: <d760cf2d0912222228y3284e455r16cdb2bfd2ecaa0e@mail.gmail.com>
 <ff435130-98a2-417c-8109-9dd029022a91@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff435130-98a2-417c-8109-9dd029022a91@default>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-12-23 09:15:27, Dan Magenheimer wrote:
> > As I mentioned, I really like the idea behind tmem. All I am proposing
> > is that we should probably explore some alternatives to achive this using
> > some existing infrastructure in kernel.
> 
> Hi Nitin --
> 
> Sorry if I sounded overly negative... too busy around the holidays.
> 
> I'm definitely OK with exploring alternatives.  I just think that
> existing kernel mechanisms are very firmly rooted in the notion
> that either the kernel owns the memory/cache or an asynchronous
> device owns it.  Tmem falls somewhere in between and is very

Well... compcache seems to be very similar to preswap: in preswap case
you don't know if hypervisor will have space, in ramzswap you don't
know if data are compressible.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
