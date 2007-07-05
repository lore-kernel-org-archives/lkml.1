Return-Path: <linux-kernel-owner+w=401wt.eu-S1760338AbXGEMWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338AbXGEMWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbXGEMWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:22:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53205 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742AbXGEMWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:22:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 14:29:06 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       mjg59@srcf.ucam.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070703211227.GA28758@srcf.ucam.org> <200707041717.05149.rjw@sisk.pl> <18060.15209.274437.471074@cargo.ozlabs.ibm.com>
In-Reply-To: <18060.15209.274437.471074@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051429.07535.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 02:29, Paul Mackerras wrote:
> Rafael J. Wysocki writes:
> 
> > They will not trigger 100% of the time, but sporadically and generally at
> > random.
> > 
> > At least the freezer problems are reproducible. ;-)
> 
> Our experience with powermacs has been that it isn't actually all that
> hard to get it right for the drivers you care about.

Well, I'm a bit suspicious about that. ;-)

Namely, if you run your suspend code on one CPU and (do I remeber correctly
that?) with kernel preemption disabled, then you practically prevent user land
processes from being scheduled when your suspend code is running.

If that is the case (of which I'm not sure), the freezer is obviously
unnecessary, because you've taken processes out of the equation in a different
way ...

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
