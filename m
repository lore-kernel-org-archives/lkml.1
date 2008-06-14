Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYFNXQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYFNXQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 19:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbYFNXP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 19:15:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54751 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbYFNXPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 19:15:55 -0400
Date: Sat, 14 Jun 2008 16:15:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 13 (x86_64: panic)
Message-Id: <20080614161556.0329d03a.randy.dunlap@oracle.com>
In-Reply-To: <20080614181646.d91dcbda.sfr@canb.auug.org.au>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
	<20080613155809.7699fc11.randy.dunlap@oracle.com>
	<20080614181646.d91dcbda.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2008 18:16:46 +1000 Stephen Rothwell wrote:

> Hi Randy,
> 
> On Fri, 13 Jun 2008 15:58:09 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > When booting linux-next-20080613, I'm seeing a panic (on x86_64):
> > 
> > 
> > Freeing unused kernel memory: 380k freed
> > Write protecting the kernel read-only data: 4616k
> > uhci_hcd: version magic '2.6.26-rc6 SMP mod_unload ' should be '2.6.26-rc6-next-20080613 SMP mod_unload '
> > ohci_hcd: version magic '2.6.26-rc6 SMP mod_unload ' should be '2.6.26-rc6-next-20080613 SMP mod_unload '
> > ehci_hcd: version magic '2.6.26-rc6 SMP mod_unload ' should be '2.6.26-rc6-next-20080613 SMP mod_unload '
> > cciss: version magic '2.6.26-rc6 SMP mod_unload ' should be '2.6.26-rc6-next-20080613 SMP mod_unload '
> 
> These look strange.  Are you sure you rebuilt and installed all your
> modules and removed any old ones lying around?

It's possibly (yet another) script problem.  I'll check it out.  Thanks.

---
~Randy
'"Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
