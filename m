Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbYJIPWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbYJIPWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbYJIPWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:22:36 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33681 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbYJIPWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:22:33 -0400
Date: Thu, 9 Oct 2008 18:21:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC - size tool for kernel build system
Message-ID: <20081009152151.GB17013@cs181140183.pp.htv.fi>
References: <48EBD268.50208@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48EBD268.50208@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 02:19:36PM -0700, Tim Bird wrote:
> I've been thinking about a tool that might be useful
> to track kernel size changes.  I'm posting this
> Request For Comments to get feedback, and determine
> if this is something that would be worthwhile to
> pursue.
> 
> What I envision is some new kernel build targets, specifically
> related to gathering size information and generating a size
> comparison report.  Some small helper scripts would be written
> to gather the necessary information, and generate the report.
>...
> Any comments?

The building blocks that would be useful are IMHO:
- a make target that generates a report for one kernel
  (like the checkstack or export_report targets)
- a script that compares two such reports and outputs the
  size differences

That's also easy to do, and if that's what's wanted I can send a patch 
that does it.

Everything else is IMHO overdesigned.

The real problem is that dumping some scripts into the kernel sources 
or publishing some data on a webpage doesn't make people use them.

Like if you run "make checkstack" on the kernel today you can see that 
drivers allocate arrays > 1 kB on the stack despite checkstack being 
available...

>  -- Tim

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

