Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZKHQQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZKHQQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZKHQQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:16:23 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41442 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZKHQQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:16:20 -0500
Date: Sun, 8 Nov 2009 17:16:25 +0100
From: Andreas Mohr <andi@lisas.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Andreas Mohr <andi@lisas.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael A. Griffith" <grif@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Please get this committed, _NOW_ (preferrably 5 years
	ago), thanks.
Message-ID: <20091108161625.GA10497@rhlx01.hs-esslingen.de>
References: <20091108120008.GA21611@rhlx01.hs-esslingen.de> <20091108144548.GA13429@rhlx01.hs-esslingen.de> <20091108151153.GC6240@hack> <200911081630.32926.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200911081630.32926.arnd@arndb.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 08, 2009 at 04:30:32PM +0100, Arnd Bergmann wrote:
> On Sunday 08 November 2009, Américo Wang wrote:
> > Yeah, I mentioned it to mean it is not suitable to explain
> > user-space problems in a kernel source file. Putting it into a kernel
> > doc should be fine.
> 
> I think it would be best to put it on a wiki page, e.g. on kernelnewbies.org
> and point to that. That means you will be able to add information to it
> independent of the kernel version.

I don't know, personally I think that's way too disconnected.
A Wiki entry might be down, might get renamed, might get converted to an
entirely different Wiki etc. Or might sit on a certain (admittedly large ;)
network that I don't have access to under certain circumstances.
In general these issues should be treated right where they're being created,
and that's the kernel.
And I don't see how "independent of the kernel version" is relevant
here. If I have such an issue, then I look into that file on a tree I
have here (which usually is a current version), and if that doesn't
help, then one could look into the exact version that (tries to) boots.


And IMHO what we should perhaps think of is inventing a reference number
scheme for people to easily look up kernel issues.
This could then be something like "LKE#1234: No init found." (L_inux
K_ernel E_rror).
OTOH this would bloat kernel messages, thus maybe there's a way to
handle it more intelligently.

Thanks,

Andreas Mohr
