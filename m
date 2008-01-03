Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYACOir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYACOir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYACOik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:38:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45596 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYACOij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:38:39 -0500
Subject: Re: [x86] kernel/audit.c cleanup according to checkpatch.pl
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080103143711.GA29606@elte.hu>
References: <20080103111925.GC8046@cvg>
	 <20080103112957.GA14693@lazybastard.org> <20080103140549.GA19363@elte.hu>
	 <1199370550.3697.79.camel@shinybook.infradead.org>
	 <20080103143711.GA29606@elte.hu>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 14:37:24 +0000
Message-Id: <1199371044.3697.80.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 15:37 +0100, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Thu, 2008-01-03 at 15:05 +0100, Ingo Molnar wrote:
> > > not to make a big issue out of this, but when was the last time you 
> > > tried to grep this way:
> > > 
> > >   grep -E "audit_rate_limit=[0-9]+ audit_backlog" */*.c
> > 
> > Not precisely that, but I've certainly had greps fail because people 
> > have split up strings to meet the stupid 80-character "limit".
> 
> yes - but if you read my whole reply you'll see that i qualified it:
> 
> >> That's pretty much the only grep pattern that would break. People 
> >> usually grep on the constant portion of the string, so breaking up a 
> >>                                                       ^^^^^^^^^^^^^
> >> line along a variable boundary is perfectly okay.

Yes, you did. But you failed to provide any good reason for actually
changing it, either. Leave it as it was.

-- 
dwmw2

