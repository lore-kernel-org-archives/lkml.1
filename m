Return-Path: <linux-kernel-owner+w=401wt.eu-S934284AbYD3WbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284AbYD3WbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763324AbYD3WbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:31:07 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60894 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764237AbYD3WbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:31:05 -0400
Subject: Re: [RFC][PATCH 3/5] Container Freezer: Implement freezer cgroup
	subsystem
From: Matt Helsley <matthltc@us.ibm.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>
In-Reply-To: <1209590905.29759.38.camel@localhost.localdomain>
References: <20080424064756.643890130@us.ibm.com>
	 <20080424064757.526468716@us.ibm.com>
	 <1209590905.29759.38.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 30 Apr 2008 15:30:49 -0700
Message-Id: <1209594649.29759.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 14:28 -0700, Matt Helsley wrote:
> On Wed, 2008-04-23 at 23:47 -0700, Matt Helsley wrote:
> 
> <snip>

> > +	cgroup_lock();
> > +
> > +	if (cgroup_is_removed(cgroup)) {
> > +		retval = -ENODEV;
> > +		goto unlock;
> > +	}
> 
> I think this was copy/paste'd from cgroup_common_file_write() which
> modifies the cgroup hierarchy. However this function does not modify the
> cgroup hierarchy and we're not getting the cgroup from the task. So I
> don't think cgroup_lock()/unlock() are needed here. Paul, do you agree?

Oops! I didn't track the call chain correctly. Sorry for the noise...

Cheers,
	-Matt Helsley


