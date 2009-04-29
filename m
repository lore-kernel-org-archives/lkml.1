Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbZD2TLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbZD2TLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZD2TLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:11:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:50186 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756850AbZD2TLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:11:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18J/uB9BQUJwrXaEkUjEZheANUvWbGnxxtil113uq
	TkfoFMnJtN0HTO
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
From: Mike Galbraith <efault@gmx.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Martin Knoblauch <knobi@knobisoft.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
In-Reply-To: <20090429143403.GJ8633@ZenIV.linux.org.uk>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>
	 <20090428182837.62c51f26.akpm@linux-foundation.org>
	 <1240977096.5478.3.camel@marge.simson.net>
	 <20090429011755.c141c599.akpm@linux-foundation.org>
	 <20090429120827.GI8633@ZenIV.linux.org.uk>
	 <1241014725.15095.19.camel@marge.simson.net>
	 <20090429143403.GJ8633@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 21:11:05 +0200
Message-Id: <1241032265.5247.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 15:34 +0100, Al Viro wrote:
> On Wed, Apr 29, 2009 at 04:18:45PM +0200, Mike Galbraith wrote:
> > > /etc/fstab, perhaps?  That definitely looks like two mount(2) had to
> > > have been done to cause that...
> > 
> > Yeah, but how does one go about doing that?
> > 
> > Using mount -f, I can convince mount to succeed, but I still have only
> > one entry in /proc/mounts, despite what my mount binary imagines.
> 
> Huh?
>        -f     Causes  everything to be done except for the actual system call;
>               if it's not obvious, this ``fakes'' mounting  the  file  system.
>               This  option is useful in conjunction with the -v flag to deter-
>               mine what the mount command is trying to do. It can also be used
>               to add entries for devices that were mounted earlier with the -n
> 
> What are you talking about?

Me?  My binary lost touch with reality, but I couldn't induce it to
produce two /proc/mount entries.  I thought that's what I said.

	-Mike

