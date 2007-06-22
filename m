Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXFVX3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXFVX3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXFVX2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:28:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49927 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXFVX2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:28:55 -0400
Date: Sat, 23 Jun 2007 00:28:51 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "C. Scott Ananian" <cscott@laptop.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc?
Message-ID: <20070622232851.GW21478@ftp.linux.org.uk>
References: <c6d9bea0706211254r6d457e36wfb3722880a3b4abd@mail.gmail.com> <200706220117.09966.arnd@arndb.de> <c6d9bea0706221551g2a50e5a1u56a11b1965fdd61d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6d9bea0706221551g2a50e5a1u56a11b1965fdd61d@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 06:51:10PM -0400, C. Scott Ananian wrote:
 
> No, clearly inotify on all files in /proc is not the right thing to
> do.  But I'm writing support for "RDNSS in RA" -- IPv6 Router
> Advertisement messages can include a DNS server specification, which
> makes IPv6 completely autoconfiguring.

Why the hell do you need idiotify on it?  Just make poll(2) work and
be done with that; see e.g. how /proc/<pid>/mounts does it.
