Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553Ab0AGB0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0AGB0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106Ab0AGB0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:26:31 -0500
Received: from RELAY-01.ANDREW.CMU.EDU ([128.2.10.212]:37749 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab0AGB0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:26:31 -0500
Date: Wed, 6 Jan 2010 20:26:06 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [PATCH v4 0/4] cgroups: support for module-loadable subsystems
Message-ID: <20100107012606.GA25577@andrew.cmu.edu>
References: <20091231051050.GA714@andrew.cmu.edu> <20100106160414.bd555474.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106160414.bd555474.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 04:04:14PM -0800, Andrew Morton wrote:
> On Thu, 31 Dec 2009 00:10:50 -0500
> Ben Blum <bblum@andrew.cmu.edu> wrote:
> 
> > This patch series implements support for building, loading, and
> > unloading subsystems as modules, both within and outside the kernel
> > source tree. It provides an interface cgroup_load_subsys() and
> > cgroup_unload_subsys() which modular subsystems can use to register and
> > depart during runtime. The net_cls classifier subsystem serves as the
> > example for a subsystem which can be converted into a module using these
> > changes.
> 
> What is the value in this?  What are the usage scenarios?  Why does the
> benefit of this change exceed the cost/risk/etc of merging it?

As discussed in the first posting of these patches, this provides the
ability for arbitrary subsystems to be used with cgroups.. cls_cgroup
would have already been a module except for a lack of support from
cgroups, and the change also allows other module-loadable classifiers
to add subsystems of their own.
