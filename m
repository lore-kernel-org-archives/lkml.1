Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694Ab0AGDKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0AGDKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601Ab0AGDKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:10:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55083 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab0AGDKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:10:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 12:07:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] cgroups: support for module-loadable subsystems
Message-Id: <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107012606.GA25577@andrew.cmu.edu>
References: <20091231051050.GA714@andrew.cmu.edu>
	<20100106160414.bd555474.akpm@linux-foundation.org>
	<20100107012606.GA25577@andrew.cmu.edu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 20:26:06 -0500
Ben Blum <bblum@andrew.cmu.edu> wrote:

> On Wed, Jan 06, 2010 at 04:04:14PM -0800, Andrew Morton wrote:
> > On Thu, 31 Dec 2009 00:10:50 -0500
> > Ben Blum <bblum@andrew.cmu.edu> wrote:
> > 
> > > This patch series implements support for building, loading, and
> > > unloading subsystems as modules, both within and outside the kernel
> > > source tree. It provides an interface cgroup_load_subsys() and
> > > cgroup_unload_subsys() which modular subsystems can use to register and
> > > depart during runtime. The net_cls classifier subsystem serves as the
> > > example for a subsystem which can be converted into a module using these
> > > changes.
> > 
> > What is the value in this?  What are the usage scenarios?  Why does the
> > benefit of this change exceed the cost/risk/etc of merging it?
> 
> As discussed in the first posting of these patches, this provides the
> ability for arbitrary subsystems to be used with cgroups.. cls_cgroup
> would have already been a module except for a lack of support from
> cgroups, and the change also allows other module-loadable classifiers
> to add subsystems of their own.

Hmm, do you have your own module in plan ?

Thanks,
-Kame

