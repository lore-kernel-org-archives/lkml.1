Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZBZWBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZBZWBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZBZWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:01:40 -0500
Received: from minbar.dodds.net ([66.93.39.86]:53723 "EHLO minbar.dodds.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbZBZWBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:01:39 -0500
Date: Thu, 26 Feb 2009 14:01:36 -0800
From: Steve Langasek <vorlon@debian.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, libpam-modules@packages.debian.org,
       debian-admin@lists.debian.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
Message-ID: <20090226220136.GA24667@dario.dodds.net>
Mail-Followup-To: Steve Langasek <vorlon@debian.org>,
	Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
	libpam-modules@packages.debian.org, debian-admin@lists.debian.org
References: <200902262248.26713.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902262248.26713.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 10:48:25PM +0100, Frans Pop wrote:
> Steve Langasek wrote:
> > It has already been mentioned that this does not apply to the upcoming
> > Debian 5.0 release (lenny); this patch is only present in the 4.0
> > release (etch), it was actually fixed in the development series to not
> > use RLIM_INFINITY *because* previous kernels didn't support this and
> > would cause pam_limits to throw log warnings.

> I've just migrated my home servers from Debian etch to lenny and bind9 now 
> gives me this:

> named[17207]: max open files (1024) is smaller than max sockets (4096)

That's a separate issue; Debian bug #515673.  I intend to solve this for
Debian 5.0.1.

-- 
Steve Langasek                   Give me a lever long enough and a Free OS
Debian Developer                   to set it on, and I can move the world.
Ubuntu Developer                                    http://www.debian.org/
slangasek@ubuntu.com                                     vorlon@debian.org
