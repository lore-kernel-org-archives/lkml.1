Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbZIIDcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbZIIDcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZIIDcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:32:41 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58582 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZIIDcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:32:41 -0400
Date: Wed, 9 Sep 2009 12:32:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Joe Perches <joe@perches.com>, Tim Abbott <tabbott@ksplice.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 2/5] Use new __init_task_data macro in arch init_task.c files.
Message-ID: <20090909033237.GC23049@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Daniel Walker <dwalker@fifo99.com>, Joe Perches <joe@perches.com>,
	Tim Abbott <tabbott@ksplice.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>
References: <1252464546-26394-1-git-send-email-tabbott@ksplice.com> <1252464546-26394-3-git-send-email-tabbott@ksplice.com> <1252465099.14793.49.camel@desktop> <1252465417.28130.3.camel@Joe-Laptop.home> <1252465625.14793.52.camel@desktop> <1252465802.28130.9.camel@Joe-Laptop.home> <1252466482.14793.60.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252466482.14793.60.camel@desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 08:21:22PM -0700, Daniel Walker wrote:
> On Tue, 2009-09-08 at 20:10 -0700, Joe Perches wrote:
> > On Tue, 2009-09-08 at 20:07 -0700, Daniel Walker wrote:
> > > On Tue, 2009-09-08 at 20:03 -0700, Joe Perches wrote:
> > > > On Tue, 2009-09-08 at 19:58 -0700, Daniel Walker wrote:
> > > > > On Tue, 2009-09-08 at 22:49 -0400, Tim Abbott wrote:
> > > > > > +union thread_union init_thread_union __init_task_data =
> > > > > > +       { INIT_THREAD_INFO(init_task) };
> > > > > All the lines like the above are all producing checkpatch errors.. It
> > > > > looks like the open brace needs to be up with the equals ..
> > > > Some checkpatch errors are ignorable.
> > > > checkpatch output is a guide, not a rule.
> > > 
> > > Not errors, those aren't usually ignorable .. Warnings, those could be..
> > 
> > Shrug.  So submit a patch...
> 
> I would if this was code in the kernel already, but it's not. LKML
> submission is the process people use to find these types of issues.
> Issues that should be fixed prior to inclusion, and may have been
> overlooked..
> 
Did you even bother reading the patch? This is exactly the format that is
in the kernel today (and even predates checkpatch), it's just that
checkpatch doesn't presently complain about it due to how the section
parsing is done. If you move the section annotation down to a separate
line, it also silences checkpatch. In this case, checkpatch is simply
broken and can be ignored. Stylistic "errors" are complete nonsense.
