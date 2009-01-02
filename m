Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbZABWbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbZABWbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZABWaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:30:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:37646 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZABWav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:30:51 -0500
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, dave@hiauly1.hia.nrc.ca
In-Reply-To: <20090102175737.GA5818@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain>
	 <20081231105425.9ccac21d.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain>
	 <20081231.141408.60544902.davem@davemloft.net>
	 <20090102115547.GB3027@elte.hu>
	 <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain>
	 <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain>
	 <20090102175737.GA5818@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 09:27:33 +1100
Message-Id: <1230935253.15389.99.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Bugger....
> Now I cannot do cross compile for: alpha, arm, m68k and sparc.
> 
> Not that I actually try to run these beasts but just being able
> to do cross compile has served me well.
> 
> Last I looked (only few days ago) crosstool-ng did not support sparc :-(

There are also various variants of 4.1.1 around with the fix for
that inline bug backported (I think that's the case of the compiler
that ships with the Cell SDK for example).

What a f. mess :-(

Cheers,
Ben.

