Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbZEBTWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbZEBTWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 15:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbZEBTWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 15:22:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63116 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbZEBTWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 15:22:00 -0400
Date: Sat, 2 May 2009 15:21:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 2/2] ftrace: add function-graph tracer support for ARM
 v2
In-Reply-To: <20090502151515.GA10418@pengutronix.de>
Message-ID: <alpine.DEB.2.00.0905021519190.30013@gandalf.stny.rr.com>
References: <49FB79CF.3020101@am.sony.com> <20090502001100.GH6404@nowhere> <20090502151515.GA10418@pengutronix.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2 May 2009, Uwe Kleine-K?nig wrote:

> Hello,
> 
> > Also I wonder how far we are from the dynamic ftrace support, which seems
> > half implemented or broken or not tested for a while?
> Commit 07c4cc1cdaa08fcb6c0275dd7be49eae37260169 suggests that "the new
> MCOUNT_RECORD method" needs to be implemented.  I don't know the
> details, though (yet).

The new MCOUNT_RECORD method means to update scripts/recordmcount.pl. 
There is an "arm" section in that script added by:

 e58918ab9d4cd375f6d842e6d88cf4d7a55cbfcc

-- Steve

