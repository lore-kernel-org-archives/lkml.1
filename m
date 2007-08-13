Return-Path: <linux-kernel-owner+w=401wt.eu-S1032044AbXHMREW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032044AbXHMREW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973350AbXHMQja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:39:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52740 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S973318AbXHMQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:39:26 -0400
Date: Mon, 13 Aug 2007 09:45:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH] x86: optionally show last exception from/to register
 contents
Message-Id: <20070813094520.26a3e6bc.randy.dunlap@oracle.com>
In-Reply-To: <20070813142110.GC3406@bingen.suse.de>
References: <46C05D91.76E4.0078.0@novell.com>
	<20070813130845.GA3406@bingen.suse.de>
	<46C0751E.76E4.0078.0@novell.com>
	<20070813142110.GC3406@bingen.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 16:21:10 +0200 Andi Kleen wrote:

> > I though you did, but since I never saw it appear in any release, I posted
> > this one...
> 
> It's a little different (and somewhat hackish I admit) 
> ftp://firstfloor.org/pub/ak/x86_64/debug/last-branch
> It has far more overhead than yours of course.
> 
> The only way to merge something like that would be dynamic
> patching and I was never quite motivated for that.
> 
> > So especially with the first concern of yours - is it worth at all rev-ing this
> > patch to address the other change requests you voiced?
> 
> The patch is useful even with the race, just document somewhere
> that it is unreliable (perhaps in the printk itself) and do the
> other changes.

and add "ler" entry to Documentation/kernel-parameters.txt, please,
with what it means.

> I would also suggest to enable it by default.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
