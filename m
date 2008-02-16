Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbYBPESe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbYBPESe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 23:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYBPESW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 23:18:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52391 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbYBPESJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 23:18:09 -0500
Date: Sat, 16 Feb 2008 13:21:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: balbir@in.ibm.com, pj@sgi.com, Pavel Emelianov <xemul@openvz.org>,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/7] CGroup API: More structured API for CGroups
 control files
Message-Id: <20080216132118.877e769b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080215204418.535025000@menage.corp.google.com>
References: <20080215204418.535025000@menage.corp.google.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 12:44:18 -0800
Paul Menage <menage@google.com> wrote:

> 
> This set of patches makes the Control Groups API more structured and
> self-describing.
> 
> 1) Allows control files to be associated with data types such as
> "u64", "string", "map", etc. These types show up in a new cgroup.api
> file in each cgroup directory, along with a user-readable
> string. Files that use cgroup-provided data accessors have these file
> types inferred automatically.
> 
> 2) Moves various files in cpusets and the memory controller from using
> custom-written file handlers to cgroup-defined handlers
> 
> 3) Adds the "cgroup." prefix for existing cgroup-provided control
> files (tasks, release_agent, releasable, notify_on_release). Given
> than we've already had 2.6.24 go out without this prefix, I guess this
> could be a little contentious - but it seems like a good move to
> prevent name clashes in the future. (Note that this doesn't affect
> mounting the legacy cpuset filesystem, since the compatibility layer
> disables all prefixes when mounted with filesystem type "cpuset"). If
> people object too strongly, we could just make this the case for *new*
> cgroup API files, but I think this is a case where consistency would
> be better than compatibility - I'd be surprised if anyone has written
> major legacy apps yet that rely on 2.6.24 cgroup control file names.
> 


Hi,  I like this direction very much. thank you for your work.
Self-describing cgroup.api file is a good idea!

One request from me is add "mode" bit to cftype for allowing
write-only/read-only files. 

Thanks,
-Kame




