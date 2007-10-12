Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbXJLGrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbXJLGrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758877AbXJLGrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:47:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58897 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394AbXJLGrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:47:12 -0400
Date: Fri, 12 Oct 2007 07:46:58 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.23-mm1
Message-ID: <20071012064658.GA8181@ftp.linux.org.uk>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com> <20071011234202.2f15bb76.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011234202.2f15bb76.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 11:42:02PM -0700, Andrew Morton wrote:
> On Fri, 12 Oct 2007 14:03:28 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 11 Oct 2007 21:31:26 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > > 
> > > - I've been largely avoiding applying anything since rc8-mm2 in an attempt
> > >   to stabilise things for the 2.6.23 merge.
> > > 
> > On RHEL5/x86_64 environment,
> > 
> > ==
> > [kamezawa@hannibal ref-2.6.23-mm1]$ make menuconfig
> > Makefile:456: /home/kamezawa/ref-2.6.23-mm1/arch//Makefile: No such file or directory
> > make: *** No rule to make target `/home/kamezawa/ref-2.6.23-mm1/arch//Makefile'.  Stop.
> > ==
> > 
> > $(ARCH) cannot be detected automatically...
> 
> So you need to set $ARCH by hand?  I always do that so I didn't notice this.
> 
> > What information is useful for fixing this ?
> 
> Sam's email address ;)

More serious breakage happened to UML - include/asm-um/arch went straight
to hell; I'll look into fixing that tomorrow...
