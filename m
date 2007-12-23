Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbXLWG1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbXLWG1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 01:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXLWG1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 01:27:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50159 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXLWG1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 01:27:39 -0500
Date: Sun, 23 Dec 2007 06:27:31 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
Message-ID: <20071223062731.GP8181@ftp.linux.org.uk>
References: <20071223053314.GA31966@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071223053314.GA31966@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 12:33:14AM -0500, Jeff Garzik wrote:
> 
> A couple [minorly] notable wireless bug fixes, and plenty of viro fixes
> for obscure issues :)

Heh...  FWIW, forcedeth patch (sent your way about two weeks ago) also
belongs in the same set.  If you need a resend - tell...

There's another pile in drivers/net/wireless, but that's for linville to
forward when he gets around to it.  Pure annotation patches belong to
past-2.6.24 merge.

I also have starfire and epic100 fixes, but that'll have to wait until
I get around to putting the cards into sparc box (mcast breakage for
starfire and full-driver one for epic100; since nobody had cared for
the latter since 2.3.late, well...)

I think I'll have an ipg fix for you tomorrow, but I want to RTFM first
to make sure that it makes sense.  And there are several interesting
issues in atl1, netxen and cxgb3, but those will have to wait for when
I get around to asking maintainers just what the hell did they mean those
to do.

FWIW, drivers/net is fairly noise-free wrt sparse endianness warnings
in my tree; the main exceptions are prism54 (oid_mgt.c and the nightmares
it pulls) and skfp (AIX-shared vendor driver; 'nuff said, IMO).

BTW, if you still have any documentation for xircom_cb from your fighting
tulip-related stuff, it would be welcome - there are some oddities with
rx ring handling (assuming that we care about that driver at all and it's
not on the way out, that is).
