Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZB0Hao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZB0Hao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZB0Hag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:30:36 -0500
Received: from anguilla.debian.or.at ([86.59.21.37]:60054 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZB0Haf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:30:35 -0500
Date: Fri, 27 Feb 2009 08:30:32 +0100
From: Peter Palfrader <weasel@debian.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, libpam-modules@packages.debian.org,
       debian-admin@lists.debian.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
Message-ID: <20090227073032.GG8217@anguilla.noreply.org>
Mail-Followup-To: Frans Pop <elendil@planet.nl>,
	linux-kernel@vger.kernel.org, libpam-modules@packages.debian.org,
	debian-admin@lists.debian.org
References: <200902262248.26713.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200902262248.26713.elendil@planet.nl>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Frans Pop wrote:

> Steve Langasek wrote:
> > It has already been mentioned that this does not apply to the upcoming
> > Debian 5.0 release (lenny); this patch is only present in the 4.0
> > release (etch), it was actually fixed in the development series to not
> > use RLIM_INFINITY *because* previous kernels didn't support this and
> > would cause pam_limits to throw log warnings.
> 
> I've just migrated my home servers from Debian etch to lenny and bind9 now 
> gives me this:
> 
> named[17207]: max open files (1024) is smaller than max sockets (4096)
> 
> Redhat's BTS [1] tells me this is a kernel issue thatshould be solved [2] 
> by the "rlimit: permit setting RLIMIT_NOFILE to RLIM_INFINITY" patch in 
> 2.6.28.
> 
> One of my servers (DNS slave) is running the standard Debian 2.6.26 
> kernel, the other (DNS master) is running 2.6.29-rc6 so that does include 
> that patch. But both show the error!

That patch has been reverted for 2.6.29 and 2.6.28.(5 or 6 or so).

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
