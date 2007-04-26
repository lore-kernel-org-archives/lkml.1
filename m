Return-Path: <linux-kernel-owner+w=401wt.eu-S1031503AbXDZUq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031503AbXDZUq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031506AbXDZUq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:46:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15762 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031503AbXDZUqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:46:55 -0400
Date: Thu, 26 Apr 2007 13:46:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: 2.6.21-rc7-mm2
Message-Id: <20070426134631.7a78b946.randy.dunlap@oracle.com>
In-Reply-To: <20070426133720.25085207.akpm@linux-foundation.org>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<46309142.2010907@googlemail.com>
	<20070426133720.25085207.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 13:37:20 -0700 Andrew Morton wrote:

> On Thu, 26 Apr 2007 13:47:14 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
> > Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/
> > >
> > >
> > > - this has everything which is in 2.6.21.  Plus more!
> > >
> > > - a number of nasty bugs were fixed.  This should be (a lot) more stable
> > >   than 2.6.21-rc7-mm1.
> > >
> > >   
> > 
> > I get this warning here :
> > 
> > 
> > drivers/net/Kconfig:2327:warning: 'select' used by config symbol 
> > 'UCC_GETH' refer to undefined symbol 'UCC_FAST'
> 
> Yes, we get so many of those that I tend to ignore them, assuming that
> someone will pick it up and fix it.
> 
> This one was added by git-powerpc, presumably
> 7d776cb596994219584257eb5956b87628e5deaf "QE: automatically select QE
> options"

There was a similar problem with PS3_xyz (don't recall exactly
which PS3_option it was) that was "solved" by introducing an
intermediate config symbol IIRC.  Maybe that trick^W fix can be
done here also...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
