Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYJ0Thx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYJ0Thx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYJ0Tho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:37:44 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:41931 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751674AbYJ0Thn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:37:43 -0400
Date: Mon, 27 Oct 2008 15:36:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [GIT PULL/RESEND] kernel message catalog patches
Message-ID: <20081027193653.GC23111@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org
References: <20081021092148.GB4980@osiris.boeblingen.de.ibm.com> <alpine.LFD.2.00.0810230835150.3287@nehalem.linux-foundation.org> <20081023210446.GA12003@osiris.boeblingen.de.ibm.com> <alpine.LFD.2.00.0810231433380.3287@nehalem.linux-foundation.org> <1225049195.14057.72.camel@localhost> <alpine.LFD.2.00.0810261212290.5200@nehalem.linux-foundation.org> <1225101688.15777.6.camel@localhost> <alpine.LFD.2.00.0810270750100.3386@nehalem.linux-foundation.org> <20081027160359.37db885c@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0810270906520.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810270906520.3386@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 09:10:56AM -0700, Linus Torvalds wrote:
> 
> I do agree. Another issue is that quite often the actual line to be 
> printed is likely fairly short, and often in an error path (so it's 
> indented and in an inconvenient place), but the explanation - even for a 
> _single_ language - may well be pretty involved and long.

It's likely that the explanation would need to be just outside the
containing function, and not in-line where it might need to be deeply
indented. 

And I think we do need separate out the question of multiple langauges
from the explanation in a single canonical language (i.e., English).
Does keeping the explanation just before the containing function mean
that it's "so far away" that it might as well be kept completely
outside of the kernel?  I don't think so, but it's probably not worth
a huge amount of effort debating it; tools for keeping an external
database in sync is a pain, but they've certainly been done before for
related problems (especially in the case of translations, where they
would have to be done that way anyway).

     	  	  	      	   	    - Ted

