Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXJRUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXJRUrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbXJRUrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:47:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57415 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbXJRUrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:47:10 -0400
Date: Thu, 18 Oct 2007 21:47:03 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Newall <david@davidnewall.com>
Cc: jaroslav.sykora@gmail.com, Jan Engelhardt <jengelh@computergmbh.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Shadow directories
Message-ID: <20071018204703.GQ8181@ftp.linux.org.uk>
References: <200710181721.09201.jara@sin.cvut.cz> <Pine.LNX.4.64.0710181802300.2936@fbirervta.pbzchgretzou.qr> <200710181907.58643.jara@sin.cvut.cz> <4717BBBB.6040205@davidnewall.com> <4717C419.8060602@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4717C419.8060602@davidnewall.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 06:07:45AM +0930, David Newall wrote:
> >considerations of this whole scheme. Linux, like most Unix systems, 
> >has never allowed hard links to directories for a number of reasons;
> 
> The claim is wrong.  UNIX systems have traditionally allowed the 
> superuser to create hard links to directories.  See link(2) for 2.10BSD 
> <http://www.freebsd.org/cgi/man.cgi?query=link&sektion=2&manpath=2.10+BSD>. 
> Having got that wrong throws doubt on the argument; perhaps a path can 
> simultaneously be a file and a directory.

Learn to read.  Linux has never allowed that.  Most of the Unix systems
do not allow that.  Original _did_ allow that, but at the cost of very
easily triggered fs corruption (and it didn't have things like rename(2) -
it _did_ have userland implementation, of course, in suid-root mv(1),
but that sucker had been extremely racy and could be easily used to
screw filesystem to hell and back; adding rename(2) to the set of primitives
combined with multiple links to directories leads to very nasty issues on
_any_ system).
