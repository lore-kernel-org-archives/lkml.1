Return-Path: <linux-kernel-owner+w=401wt.eu-S1766899AbXDSRjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766899AbXDSRjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766898AbXDSRjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:39:22 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:45944 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1766899AbXDSRjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:39:21 -0400
Subject: Re: AppArmor FAQ
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f085og$3hg$1@taverner.cs.berkeley.edu>
References: <20070417181016.GA10903@one.firstfloor.org>
	 <Line.LNX.4.64.0704180935100.25495@d.namei> <4626746A.9010701@novell.com>
	 <Line.LNX.4.64.0704181620130.27545@d.namei>
	 <f085og$3hg$1@taverner.cs.berkeley.edu>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 19 Apr 2007 13:39:08 -0400
Message-Id: <1177004348.27654.139.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 16:35 +0000, David Wagner wrote:
> James Morris  wrote:
> >On Wed, 18 Apr 2007, Crispin Cowan wrote:
> >> How is it that you think a buffer overflow in httpd could allow an
> >> attacker to break out of an AppArmor profile?
> >
> >Because you can change the behavior of the application and then bypass 
> >policy entirely by utilizing any mechanism other than direct filesystem 
> >access: IPC, shared memory, Unix domain sockets, local IP networking, 
> >remote networking etc.
> 
> Any halfway decent jail will let you control access to all of those
> things, thereby preventing an 0wned httpd from breaking out of the jail.
> (For instance, Janus did.  So does Systrace.)
> 
> Are you saying AppArmor does not allow that kind of control?  Specifics
> would be useful.

Just look at their code and their own description of AppArmor.  It does
not provide that level of control, and by your own metric, it is thus
not a halfway decent jail.  Which begs the question - if that is the
kind of approach you want, why not use a real jail/containers mechanism
for it?

> >Also worth noting here is that you have to consider any limited 
> >environment as enforcing security policy, and thus its configuration 
> >becomes an additional component of security policy.
> 
> I don't understand what you are saying.  Yes, the AppArmor policy
> file is part of policy.  Is that what you mean?

I think he means the dependencies on which AppArmor relies, not just its
policy, e.g. since it is name-based, it presumes the filesystem
namespace has been set up by a trusted agent and is correct. 

-- 
Stephen Smalley
National Security Agency

