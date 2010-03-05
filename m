Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0CEUto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:49:44 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33967 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab0CEUtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:49:43 -0500
Date: Fri, 5 Mar 2010 12:49:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       geert@linux-m68k.org
Subject: Re: [PATCH] v3 kconfig: place git SHA1 in .config output if in SCM
Message-ID: <20100305204941.GI6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100305025435.GA6836@linux.vnet.ibm.com> <201003051818.10486.elendil@planet.nl> <20100305201051.GG6764@linux.vnet.ibm.com> <201003052131.12199.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003052131.12199.elendil@planet.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 09:31:10PM +0100, Frans Pop wrote:
> (Dropping cloos as that address is bouncing my mails.)
> 
> On Friday 05 March 2010, Paul E. McKenney wrote:
> > s/you're over-designing this/you are freaking paranoid/
> 
> Whatever makes you happy :-)

;-)

> > With that change, I plead guilty to charges as read.  But again, I am
> > worried about the case where one person generates the .config file
> > and someone else is reading it.
> 
> Not sure that's very relevant. A person reading it will still get the same 
> oldfashioned basic info as when a build is done from a tree that's not 
> under an SCM. And he won't really be in a position where he can fix the 
> errors anyway.

But the person reading it is in a position to ask the person sending the
.config to fix their build system.

							Thanx, Paul
