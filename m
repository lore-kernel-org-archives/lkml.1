Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbZFPJY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbZFPJY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZFPJYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:24:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZFPJYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:24:18 -0400
Date: Tue, 16 Jun 2009 11:24:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Bruno Bauer <bgbauer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Scheduler and SMP
In-Reply-To: <afc5d28f0906131444m11eedd4l4477266135cb869c@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0906161122380.31685@twin.jikos.cz>
References: <afc5d28f0906131444m11eedd4l4477266135cb869c@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009, Bruno Bauer wrote:

> I'm new in kernel development and i be making tests in scheduler for a
> study course.

I guess kernelnewbies malinglist would be more appropriate for you than 
lkml.

> I created a new syscall that set a task for no migrate from cpu (I added 
> a new flag no_migrate on task_struct). 

Why didn't you use existing infrastructure (sched_setaffinity()) for that?

> In my tests, a tar/bzip task with no_migrate flag seted run at 5% more 
> fast.
> How do this be explained? Overhead of migration?

Probably. Depends on the exact changes you have made, which you haven't 
shared with us.

-- 
Jiri Kosina
SUSE Labs

