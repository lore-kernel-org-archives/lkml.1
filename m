Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbZHTEjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbZHTEjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 00:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZHTEjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 00:39:00 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42742 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbZHTEi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 00:38:59 -0400
Date: Wed, 19 Aug 2009 21:38:58 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, bblum@andrew.cmu.edu, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] Lets ss->can_attach and ss->attach do whole
	threadgroups at a time
Message-ID: <20090820043858.GD29801@count0.beaverton.ibm.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235837.22531.86001.stgit@menage.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818235837.22531.86001.stgit@menage.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 04:58:38PM -0700, Paul Menage wrote:
> From: Ben Blum <bblum@google.com>
> 
> 
> Lets ss->can_attach and ss->attach do whole threadgroups at a time
> 
> This patch alters the ss->can_attach and ss->attach functions to be able to
> deal with a whole threadgroup at a time, for use in cgroup_attach_proc. (This
> is a pre-patch to cgroup-procs-writable.patch.)
> 
> Currently, new mode of the attach function can only tell the subsystem about
> the old cgroup of the threadgroup leader. No subsystem currently needs that
> information for each thread that's being moved, but if one were to be added
> (for example, one that counts tasks within a group) this bit would need to be
> reworked a bit to tell the subsystem the right information.
> 
> Signed-off-by: Ben Blum <bblum@google.com>
> Signed-off-by: Paul Menage <menage@google.com>

freezer bits:

Reviewed-by: Matt Helsley <matthltc@us.ibm.com>
