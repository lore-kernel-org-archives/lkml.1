Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYAKJcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYAKJcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYAKJcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:32:15 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:42305 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbYAKJcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:32:14 -0500
Subject: Re: [PATCH] checkpatch.pl: allow piping
From: Daniel Walker <dwalker@mvista.com>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Jiri Slaby <jirislaby@gmail.com>, apw@shadowen.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
In-Reply-To: <1200043399.3905.9.camel@gimli.at.home>
References: <20080111041120.085610726@mvista.com>
	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>
	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 01:30:27 -0800
Message-Id: <1200043827.29897.70.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 10:23 +0100, Bernd Petrovitsch wrote:
> On Fre, 2008-01-11 at 10:21 +0100, Jiri Slaby wrote:
> > On 01/11/2008 10:17 AM, Daniel Walker wrote:
> > > On Fri, 2008-01-11 at 09:52 +0100, Jiri Slaby wrote:
> > >> On 01/11/2008 05:10 AM, Daniel Walker wrote:
> > >>> A little feature addition to allow checkpatch.pl to check
> patches piped
> > >>> into it, in addition to specific file arguments.
> > >> You can still add - as an argument to check stdin. In which way
> is this better?
> > > 
> > > There's was no reason to limit the arguments ..
> > > 
> > > I was using it to do something like the following ,
> > > 
> > > git show 9914cad54c79d0b89b1f066c0894f00e1344131c
> | ./scripts/checkpatch.pl
> > 
> > Ok, and if you add a - there, it should have the same effect, but
> for free, 
> > doesn't it:
> > git show 9914cad54c79d0b89b1f066c0894f00e1344131c
> | ./scripts/checkpatch.pl -
> 
> JftSoC:
> git show 9914cad54c79d0b89b1f066c0894f00e1344131c
> | ./scripts/checkpatch.pl /dev/stdin
> (and there a a few others) should also do the trick.

Not a particularly attractive command line .. Might still be a good idea
to add this since these two forms alluded me, and are likely to allude
people new to unix all together (who is more likely to be using this
particular tool)..

Daniel

