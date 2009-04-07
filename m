Return-Path: <linux-kernel-owner+w=401wt.eu-S1751396AbZDGEF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbZDGEF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZDGEFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:05:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbZDGEFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:05:17 -0400
Date: Mon, 6 Apr 2009 21:03:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-04-05-21-45 uploaded
Message-Id: <20090406210322.10916bf4.akpm@linux-foundation.org>
In-Reply-To: <20090407121958.8e544e90.kamezawa.hiroyu@jp.fujitsu.com>
References: <200904060450.n364oaUj031923@imap1.linux-foundation.org>
	<49DA596A.5090104@oracle.com>
	<20090407121958.8e544e90.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 12:19:58 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 06 Apr 2009 12:35:06 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2009-04-05-21-45 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://git.zen-sources.org/zen/mmotm.git
> > > 
> > > It contains the following patches against 2.6.29:
> > 
> > 
> > Duplicate functions merged here (2 functions duplicated),
> > so *all* (of my) builds fail with these errors:
> > 
> > 
> > mmotm-2009-0405-2145/scripts/kallsyms.c:550: error: redefinition of 'may_be_linker_script_provide_symbol'
> > mmotm-2009-0405-2145/scripts/kallsyms.c:505: error: previous definition of 'may_be_linker_script_provide_symbol' was here
> > mmotm-2009-0405-2145/scripts/kallsyms.c:584: error: redefinition of 'prefix_underscores_count'
> > mmotm-2009-0405-2145/scripts/kallsyms.c:539: error: previous definition of 'prefix_underscores_count' was here
> > 
> > 
> Maybe  kallsyms-tracing-output-more-proper-symbol-name.patch is applied twice
> by linux-next.path.
> 

Yep. 
