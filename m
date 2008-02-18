Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYBROXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYBROXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYBROXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:23:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYBROXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:23:00 -0500
Date: Mon, 18 Feb 2008 11:22:43 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: Reducing debuginfo size by removing unneeded includes
Message-ID: <20080218142243.GI4359@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20080207230304.GA4352@ghostprotocols.net> <p73ir0mxvby.fsf@bingen.suse.de> <20080218134100.GE4359@ghostprotocols.net> <20080218145006.GA26286@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218145006.GA26286@one.firstfloor.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 18, 2008 at 03:50:06PM +0100, Andi Kleen escreveu:
> > I found just it to be another reason for cleaning up the includes hell,
> > but I agree completely that the correct solution is for gcc to do the
> > right thing and eliminate unused debug types.
> 
> Yes, but I'm a little disappointed that it doesn't work either.
> I remember long ago trying an original patch which did something
> similar to -feliminate-dwarf2-* on a 3.3-hammer based gcc and
> it actually shrunk the objdir size considerably.

>From my limited set of tests I expect it to shrunk the objdir by a lot
:-)

- Arnaldo
