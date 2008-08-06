Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYHFAqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYHFAqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbYHFAqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:46:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbYHFAqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:46:10 -0400
Date: Tue, 5 Aug 2008 20:46:00 -0400
From: Rik van Riel <riel@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro
 toalinuxinterfaceforonaccess scanning
Message-ID: <20080805204600.03ceca31@bree.surriel.com>
In-Reply-To: <1217982329.27684.214.camel@localhost.localdomain>
References: <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	<20080805185438.GA8453@mit.edu>
	<2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com>
	<20080805211445.GA28304@kroah.com>
	<2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com>
	<20080805214415.GA5830@kroah.com>
	<2629CC4E1D22A64593B02C43E855530303E21D47@USILMS12.ca.com>
	<20080805222638.GA6395@kroah.com>
	<20080805233743.GK28946@ZenIV.linux.org.uk>
	<1217980132.27684.203.camel@localhost.localdomain>
	<20080806001124.GA9079@kroah.com>
	<1217982329.27684.214.camel@localhost.localdomain>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug 2008 20:25:29 -0400
Eric Paris <eparis@redhat.com> wrote:

> I don't think its hiding, I'm attempting to bring these companies who
> just don't understand how to work in public

That's not my worry.

My real worry is that the anti-virus companies have been working
with an enforcement policy that has been evolving slowly from the
DOS days, while today's threat model has changed considerably.

I do not see how the proposed hooks would close off a system
sufficiently to claim anything approaching security.

The way forward is to:
1) define a threat model
2) figure out what infrastructure is needed for protection
3) come up with interfaces that also help other software
   (eg. file range inotify to help disk indexing software)

Trying to shoe-horn the DOS anti-virus security model into a
multi-user operating system with networking may not be sufficient
protection for today's world.  Eg. it does not protect against
script virusses fetched off web sites and executed directly in
a browser, office suite or any gnome-vfs enabled program. This
is a major vulnerability in modern systems.

What problem are we really trying to solve?

Which problems are out of scope?

What infrastructure can solve the problem, while being useful 
for other things too?

-- 
All rights reversed.
