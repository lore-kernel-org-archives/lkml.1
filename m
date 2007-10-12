Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbXJLGmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbXJLGmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXJLGmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:42:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031AbXJLGmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:42:10 -0400
Date: Thu, 11 Oct 2007 23:42:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.23-mm1
Message-Id: <20071011234202.2f15bb76.akpm@linux-foundation.org>
In-Reply-To: <20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 14:03:28 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 11 Oct 2007 21:31:26 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > 
> > - I've been largely avoiding applying anything since rc8-mm2 in an attempt
> >   to stabilise things for the 2.6.23 merge.
> > 
> On RHEL5/x86_64 environment,
> 
> ==
> [kamezawa@hannibal ref-2.6.23-mm1]$ make menuconfig
> Makefile:456: /home/kamezawa/ref-2.6.23-mm1/arch//Makefile: No such file or directory
> make: *** No rule to make target `/home/kamezawa/ref-2.6.23-mm1/arch//Makefile'.  Stop.
> ==
> 
> $(ARCH) cannot be detected automatically...

So you need to set $ARCH by hand?  I always do that so I didn't notice this.

> What information is useful for fixing this ?

Sam's email address ;)
