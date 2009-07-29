Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZG2PGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZG2PGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZG2PGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:06:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54084 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZG2PGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:06:19 -0400
Date: Wed, 29 Jul 2009 17:06:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@namei.org, spender@grsecurity.net,
       dwalsh@redhat.com, cl@linux-foundation.org, arjan@infradead.org,
       kyle@mcmartin.ca, cpardy@redhat.com, arnd@arndb.de
Subject: Re: [PATCH 1/2] VM/SELinux: require CAP_SYS_RAWIO for all
	mmap_zero operations
Message-ID: <20090729150612.GF1534@ucw.cz>
References: <20090721144157.14159.23439.stgit@paris.rdu.redhat.com> <20090721160437.5bda68b4@lxorguk.ukuu.org.uk> <1248189524.2654.301.camel@localhost> <20090721163813.0cb5d7ab@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721163813.0cb5d7ab@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-07-21 16:38:13, Alan Cox wrote:
> > turns it off for the whole system when you install WINE.  This patch
> > doesn't change that fact.  All it does is add that requirement to
> > SELinux systems that already exists on non-selinux systems.
> 
> Prior to this an SELinux system could implement sensible security. The
> fact Fedora didn't was paranoia and fear over a bad experience made what
> five years ago ?

OTOH enabling selinux previously only taken your rights away... which
is not the case with min_mmap_addr. Making it consistent seems useful.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
