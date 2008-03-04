Return-Path: <linux-kernel-owner+w=401wt.eu-S934681AbYCDX32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934681AbYCDX32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935266AbYCDXXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:23:51 -0500
Received: from c60.cesmail.net ([216.154.195.49]:29424 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935205AbYCDXXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:23:49 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: Pavel Roskin <proski@gnu.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20080304212023.GD31546@elte.hu>
References: <1204305609.21719.16.camel@dv>
	 <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
	 <1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu>
	 <1204324265.2316.70.camel@dv> <20080303105752.GA23594@elte.hu>
	 <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net>
	 <20080304125744.GF29777@elte.hu>
	 <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org>
	 <1204652732.2312.18.camel@dv>  <20080304212023.GD31546@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 18:23:48 -0500
Message-Id: <1204673028.3479.21.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 22:20 +0100, Ingo Molnar wrote:
> * Pavel Roskin <proski@gnu.org> wrote:
> 
> > To recap:
> > 
> > 1) USB API
> > 2) Workqueue API (there is a hackish replacement in ndiswrapper)
> > 3) task_nice(), but I have a trivial workaround for that.
> 
> task_nice() - it's trivial so feel free to send a patch that turns it 
> into EXPORT_SYMBOL().

The recent discussion makes me nervous about sending any patches of such
kind.  Instead of getting access task_nice(), ndiswrapper could lose
access to set_user_nice() or something else.

It's bad already that a mistaken commit has turned into a permanent
restriction for ndiswrapper after my intervention :-(

-- 
Regards,
Pavel Roskin
