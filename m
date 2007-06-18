Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbXFRPlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbXFRPlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763237AbXFRPlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:41:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18314 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762610AbXFRPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:41:09 -0400
Date: Mon, 18 Jun 2007 08:35:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Gerrit Huizenga <gh@us.ibm.com>, holzheu@linux.vnet.ibm.com,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-Id: <20070618083549.67464f6b.randy.dunlap@oracle.com>
In-Reply-To: <20070618131157.GA23229@uranus.ravnborg.org>
References: <1181817533.10064.18.camel@localhost.localdomain>
	<E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com>
	<20070618131157.GA23229@uranus.ravnborg.org>
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

On Mon, 18 Jun 2007 15:11:57 +0200 Sam Ravnborg wrote:

> On Fri, Jun 15, 2007 at 11:42:15AM -0700, Gerrit Huizenga wrote:
> > 
> > Andrew mentioned a mechanism for adding a subsystem tag or other tag
> > which helps disambiguate the message, either in the message file or in
> > the end user documentation (e.g. the Message Pedia/mPedia that the Japanese
> > have already created with ~350 messages, and a total of ~700 targetted
> > by the end of the year).
> > 
> > That tag could be appended to the beginning of the printk, to the end of
> > the printk, or even in a formatted comment at the end of the printk that
> > the tool could extract.
> 
> The best way to maintain such a subsystem tag most be supported by
> kbuild. So say we have the subsystem "scsi" then we can set this subsystem
> tag in drivers/scsi/Makefile and let drivers/scsi/arm/Makefile inherit
> this vaule doing nothing.
> 
> Addign the subsystem tag to the printk could than be done using the
> C preprocessor and we are all fine.
> 
> If we go by the kernel-doc way to document kernel messages (the few that
> actually needs additional explanation) then we need to teach kernel-doc
> to collect the same subsystem tag but that should be doable.

Actually I would prefer that such a tool be a clone of
scripts/kernel-doc and use a (slightly?) modified tag instead of
the kernel-doc "/**" tag if this route is used at all.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
