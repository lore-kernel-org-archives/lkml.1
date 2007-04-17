Return-Path: <linux-kernel-owner+w=401wt.eu-S1161369AbXDQS1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161369AbXDQS1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161366AbXDQS1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:27:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44204 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161373AbXDQS1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:27:30 -0400
Date: Tue, 17 Apr 2007 11:30:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: piet@bluelane.com
Cc: Tom Rini <trini@kernel.crashing.org>, Andi Kleen <ak@suse.de>,
       Dave Jiang <djiang@mvista.com>, linux-kernel@vger.kernel.org,
       sshtylyov@ru.mvista.com, Andrew Morton <akpm@osdl.org>,
       George Anzinger <george@wildturkeyranch.net>,
       "David O'Brien" <obrien@FreeBSD.org>
Subject: Re: Permanent Kgdb integration into the kernel - lets get with it.
Message-Id: <20070417113016.1f0812c7.randy.dunlap@oracle.com>
In-Reply-To: <1173392650.8912.236.camel@piet2.bluelane.com>
References: <20070307204516.GA24095@blade.az.mvista.com>
	<200703081814.53153.ak@suse.de>
	<45F04B6E.9000703@mvista.com>
	<200703081937.56167.ak@suse.de>
	<20070308184940.GP11626@smtp.west.cox.net>
	<1173392650.8912.236.camel@piet2.bluelane.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2007 14:24:10 -0800 Piet Delaney wrote:

> On Thu, 2007-03-08 at 11:49 -0700, Tom Rini wrote:
> > On Thu, Mar 08, 2007 at 07:37:56PM +0100, Andi Kleen wrote:
> > > On Thursday 08 March 2007 18:44, Dave Jiang wrote:
> > > 
> > > > In spite of kgdb, shouldn't it have that \n anyways in case some other code
> > > > gets added in the future after the macro? Or are you saying that there should
> > > > never be any code ever after that macro?
> > > 
> > > Sure if there is mainline code added after that macro we add the \n.
> > > But only if it makes sense to add code there, which it didn't in kgdb.
> > 
> > Was that because with recent enough tools and config options there was
> > enough annotations so GDB could finally figure out where things had
> > stopped?  Thanks.
> 
> The reason Linus said he didn't allow George's kgdb mm patch to 
> be integrating into the kernel a year or two ago was that Amit and
> George had significantly different implementations. So Amit, Tom, 
> George, and the rest of the kgdb development gang worked together 
> and came up with a unified version that we now support on SourceForge. 
> 
> Tom rolled up a mm patch back in December for Andrew and then the
> integration process stopped. I suggest we work together on getting
> the kgdb patch back into the mm series and permanently into the kernel
> like the kexec code and then we can avoid this kernel development
> obfuscation.

Hi,
Is there any movement on this?

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
