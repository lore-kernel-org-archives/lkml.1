Return-Path: <linux-kernel-owner+w=401wt.eu-S2992536AbXCGXIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992536AbXCGXIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992700AbXCGXIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:08:41 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36865 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992536AbXCGXIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:08:40 -0500
Date: Wed, 7 Mar 2007 15:05:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Petr =?ISO-8859-1?Q?Tesa=5F?= =?ISO-8859-1?Q?=5F=EDk?= 
	<ptesarik@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] remove_arg_zero() rewrite
Message-Id: <20070307150530.73463dc5.randy.dunlap@oracle.com>
In-Reply-To: <1173308113.4868.11.camel@lappy>
References: <1171978145.22720.21.camel@golias.tesarici.cz>
	<20070221154159.d316d526.akpm@linux-foundation.org>
	<1173305397.4868.4.camel@lappy>
	<20070307144101.f97cfa53.akpm@linux-foundation.org>
	<1173308113.4868.11.camel@lappy>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 23:55:12 +0100 Peter Zijlstra wrote:

> On Wed, 2007-03-07 at 14:41 -0800, Andrew Morton wrote:
> > On Wed, 07 Mar 2007 23:09:57 +0100
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Wed, 2007-02-21 at 15:41 -0800, Andrew Morton wrote:
> > > 
> > > > I mean.... what the hell?
> > > > 
> > > > As you appear to have managed to work out what the sorry thing is trying to
> > > > do, would you have time to simply rip it out and completely rewrite it,
> > > > including a nice comment telling the world what this function's function is?
> > > > 
> > > > Because what we have there is beyond repairing.
> > > 
> > > Something like so?
> > > Boots uml seemingly without errors.
> > > 
> > > ---
> > > Rewrite remove_arg_zero() to be more parseable by untwisted minds.
> > > 
> > 
> > Sorry, Nick already had a go at this:
> 
> Darn, must've fell off of lkml... or I missed it catching up my 4000+
> email backlog.

Hm, I've had a similar issue.  Mail problems or what...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
