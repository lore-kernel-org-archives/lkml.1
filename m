Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbYAYWeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbYAYWeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYAYWd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:33:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbYAYWd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:33:57 -0500
Date: Fri, 25 Jan 2008 14:33:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 183/196] driver core: fix build with SYSFS=n
Message-Id: <20080125143324.5ef53876.akpm@linux-foundation.org>
In-Reply-To: <20080125222530.GA23769@elte.hu>
References: <20080125071127.GA4860@kroah.com>
	<1201246425-5058-104-git-send-email-gregkh@suse.de>
	<20080125222530.GA23769@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 25 Jan 2008 23:25:30 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> * Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > When SYSFS=n and MODULES=y, build ends with:
> > 
> > linux-2.6.24-rc6-mm1/drivers/base/module.c: In function 'module_add_driver':
> > linux-2.6.24-rc6-mm1/drivers/base/module.c:49: error: 'module_kset' undeclared (first use in this function)
> > make[3]: *** [drivers/base/module.o] Error 1
> 
> _PLEASE_ fold such fixes into the patch that introduces the build bugs, 
> prior sending your git trees upstream! (just like Andrew does it with 
> all patches that come via -mm)
> 
> Changes like this (and it now leaked into Linus' tree as well) kill 
> bisectability.
> 

Absolutely - this is important.  After several hours mucking about I just
gave up trying to bisect a 2.6.24-rc1 regression due to hitting 100% build
errors and runtime oopses during the bisection.  Mainly from networking in
that case.
