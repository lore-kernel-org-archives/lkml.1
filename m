Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZL2U0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZL2U0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZL2U0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:26:11 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:53384 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZL2U0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:26:09 -0500
Date: Tue, 29 Dec 2009 21:26:03 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's the purpose of MAXHOSTNAMELEN?
Message-ID: <20091229202603.GM4815@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jeff Garzik <jeff@garzik.org>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0912291416230.4967@localhost> <4B3A5B15.5060807@garzik.org> <20091229195608.GG4815@const> <4B3A64A8.5040104@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B3A64A8.5040104@garzik.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik, le Tue 29 Dec 2009 15:20:56 -0500, a écrit :
> >>What is it used for in userspace, and why is it export from the kernel?
> >
> >Gethostname, typically, but also all kinds of functions that provide a
> >hostname.  It's also quite often completely badly used, for instance for
> >getnameinfo()...
> >
> >You have Debian's list on
> >http://unstable.buildd.net/buildd/hurd-i386_Failed.html
> 
> No one cares about Hurd.

That wasn't at all the point of my inclusion of the URL, see above.  If
you drop it, you'll get all kinds of build failures.  I just happened to
use the Debian Hurd build failures as a quick way to get a list.

Samuel
