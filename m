Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZIIDKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZIIDKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZIIDKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:10:00 -0400
Received: from mail.perches.com ([173.55.12.10]:1051 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZIIDJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:09:59 -0400
Subject: Re: [PATCH v2 2/5] Use new __init_task_data macro in arch
 init_task.c files.
From: Joe Perches <joe@perches.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1252465625.14793.52.camel@desktop>
References: <1252464546-26394-1-git-send-email-tabbott@ksplice.com>
	 <1252464546-26394-3-git-send-email-tabbott@ksplice.com>
	 <1252465099.14793.49.camel@desktop>
	 <1252465417.28130.3.camel@Joe-Laptop.home>
	 <1252465625.14793.52.camel@desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Sep 2009 20:10:02 -0700
Message-Id: <1252465802.28130.9.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 20:07 -0700, Daniel Walker wrote:
> On Tue, 2009-09-08 at 20:03 -0700, Joe Perches wrote:
> > On Tue, 2009-09-08 at 19:58 -0700, Daniel Walker wrote:
> > > On Tue, 2009-09-08 at 22:49 -0400, Tim Abbott wrote:
> > > > +union thread_union init_thread_union __init_task_data =
> > > > +       { INIT_THREAD_INFO(init_task) };
> > > All the lines like the above are all producing checkpatch errors.. It
> > > looks like the open brace needs to be up with the equals ..
> > Some checkpatch errors are ignorable.
> > checkpatch output is a guide, not a rule.
> 
> Not errors, those aren't usually ignorable .. Warnings, those could be..

Shrug.  So submit a patch...

cheers, Joe

