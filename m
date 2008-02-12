Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbYBLVZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbYBLVZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYBLVZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:25:32 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:39646 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbYBLVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:25:30 -0500
Date: Tue, 12 Feb 2008 14:25:28 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212212528.GG18225@parisc-linux.org>
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org> <20080212204813.GA21650@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212204813.GA21650@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:48:13PM -0800, Greg KH wrote:
> I have tried, and successfully done this many times in the past.  The
> kobject change was one example: add a new function, migrate all users of
> a direct pointer over to that function, after that work is all done and
> in, change the structure and do the needed work afterward.  All is
> bisectable completly, with no big "flag day" needed.

That takes care of bisectability, but doesn't take care of the problem
of new stuff being merged which used the old API and is now broken.

Maybe the last step (removal of old API) needs to be taken a lot later
than it currently is (maybe a second merge window between -rc1 and -rc2
for removal of interfaces that became unused during the first merge
window before -rc1?)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
