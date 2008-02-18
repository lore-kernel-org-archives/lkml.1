Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYBROOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYBROOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYBROOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:14:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43856 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYBROOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:14:06 -0500
Date: Mon, 18 Feb 2008 15:50:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: Reducing debuginfo size by removing unneeded includes
Message-ID: <20080218145006.GA26286@one.firstfloor.org>
References: <20080207230304.GA4352@ghostprotocols.net> <p73ir0mxvby.fsf@bingen.suse.de> <20080218134100.GE4359@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218134100.GE4359@ghostprotocols.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I found just it to be another reason for cleaning up the includes hell,
> but I agree completely that the correct solution is for gcc to do the
> right thing and eliminate unused debug types.

Yes, but I'm a little disappointed that it doesn't work either.
I remember long ago trying an original patch which did something
similar to -feliminate-dwarf2-* on a 3.3-hammer based gcc and
it actually shrunk the objdir size considerably.

-Andi
