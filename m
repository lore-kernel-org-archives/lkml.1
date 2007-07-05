Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbXGELrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbXGELrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbXGELrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:47:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52980 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbXGELrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:47:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 13:54:36 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707041630.30048.rjw@sisk.pl> <18060.14341.341604.666867@cargo.ozlabs.ibm.com>
In-Reply-To: <18060.14341.341604.666867@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051354.37671.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 02:15, Paul Mackerras wrote:
> Rafael J. Wysocki writes:
> 
> > This is incompatible with the code in kernel/power/main.c, since we only
> > disable the nonboot CPUs after devices have been suspended.  Do you think that
> > your framework can be modified to work without disabling the nonboot CPUs
> > by the user space?
> 
> Sure.  It was a "if it can be done in userspace, do it in userspace"
> kind of decision, but I'm not wedded to it.
> 
> I actually do want to converge to using the generic suspend-to-ram
> code on powerbooks.  I just want to avoid causing regressions for
> powerbook users, including myself. :)

Okay, but my question is this: Would that be possible, within your framework,
to disable the nonboot CPUs _after_ suspending devices?

Can you please point me to your high-level suspend code?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
