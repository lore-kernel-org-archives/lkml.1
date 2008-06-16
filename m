Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbYFPCJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbYFPCJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 22:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYFPCIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 22:08:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32948 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYFPCIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 22:08:50 -0400
Date: Mon, 16 Jun 2008 11:07:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] introduce task cgroup v2
Cc: kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080613214626.9afc892f.randy.dunlap@oracle.com>
References: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080613214626.9afc892f.randy.dunlap@oracle.com>
Message-Id: <20080616110609.7893.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

sorry for so late responce.
REALLY REALLY Thank you for your professional review!

I'll merge it.

> > Index: b/init/Kconfig
> > ===================================================================
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -289,6 +289,16 @@ config CGROUP_DEBUG
> >  
> >  	  Say N if unsure
> >  
> > +config CGROUP_TASK
> > +	bool "Simple number of task accounting cgroup subsystem"
> > +	depends on CGROUPS && EXPERIMENTAL
> > +	default n
> > +	help
> > +          Provides a simple number of task accounting cgroup subsystem for
> 
> Indent help test one tab + 2 spaces, please.
> s/for/to/

(snip)



