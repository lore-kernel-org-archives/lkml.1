Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYIDRhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYIDRhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYIDRha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:37:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbYIDRha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:37:30 -0400
Date: Thu, 4 Sep 2008 10:36:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, arjan@linux.intel.com,
       mingo@elte.hu
Subject: Re: +
 fix-fastboot-make-the-raid-autodetect-code-wait-for-all-devices-to-init.patch
 added to -mm tree
Message-Id: <20080904103646.1826d797.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0809040941550.19666@shark.he.net>
References: <200809040539.m845dEgX022904@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0809040941550.19666@shark.he.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 09:45:10 -0700 (PDT) "Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> On Wed, 3 Sep 2008, akpm@linux-foundation.org wrote:
> 
> > Subject: fix "fastboot: make the raid autodetect code wait for all devices to init"
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > : commit b52c36a95ed8026b6925fe8595ebcab6921ae62d
> > : Author: Arjan van de Ven <arjan@linux.intel.com>
> > : Date:   Sun Jul 20 13:07:09 2008 -0700
> > :
> > :     fastboot: make the raid autodetect code wait for all devices to init
> > 
> > init/do_mounts_md.c: In function `md_run_setup':
> > init/do_mounts_md.c:282: warning: ISO C90 forbids mixed declarations and code
> > 
> > How did this happen?
> 
> There are so many warnings that they get lost in the noise
> unless someone is actively looking for them.

Well if that's the explanation then OK (sort-of).  I'm more concerned
that the warning does not appear *at all* for some people's
compiler/Kconfig combinations.

