Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbXGPHgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbXGPHgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXGPHgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:36:03 -0400
Received: from ns1.suse.de ([195.135.220.2]:52252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbXGPHgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:36:00 -0400
Date: Mon, 16 Jul 2007 09:35:33 +0200
From: Stefan Seyfried <seife@suse.de>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, Henne <henne@nachtwindheim.de>,
       Arjan van de Ven <arjan@infradead.org>,
       "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][BUTTON] remove procfs-interface
Message-ID: <20070716073533.GA23083@suse.de>
References: <4695F726.7030203@nachtwindheim.de> <823A93EED437D048963A3697DB0E35DE7314AB@pdsmsx414.ccr.corp.intel.com> <a781481a0707121207o3497edbye9f89c9f2589f3e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a781481a0707121207o3497edbye9f89c9f2589f3e5@mail.gmail.com>
X-Operating-System: openSUSE 10.3 (i586) Alpha5plus, Kernel 2.6.22-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 12:37:07AM +0530, Satyam Sharma wrote:
> On 7/12/07, Zhang, Rui <rui.zhang@intel.com> wrote:
> >Well, the ACPI sysfs conversion is not finished yet
> >[...]
> >I'm not sure if the button sysfs I/F is already finished.
> >We'd better make a double check. :)
> 
> Ok, this sounds reasonable.
> 
> >and some user space tools still use the ACPI procfs.
> 
> But this does *not*, IMHO. It quite defeats the whole concept of
> feature-removal-schedule.txt. I think that file exists precisely
> because we cannot gratuitously break userspace interfaces just
> like that, but when something gets put up there with a removal date
> that is a good one year in the future, and userspace tools _still_
> continue to use it ... then, I suspect something's seriously wrong.

Holy sh*t. There is not even a functional replacement ready, but still
everybody wants to remove /proc/acpi. (Maybe the replacement started
to work recently, i have not looked into this area for the last months.
This does not change my pint, though).
This is not going to work.
IMNSHO, we need the new interface available and usable for quite some time
(i'd say for over one year), and then we can start to phase out the old
interface.
Starting with removing /proc/acpi is not the correct ordering of actions.
 
> Either the feature-removal-schedule.txt file has become something
> that users don't even bother checking, or else, they _know_ that
> even if they don't bother keeping up with the pace in kernel-land,
> that interface still won't go away (because they're still using it!).

Or they look at the feature-removal document, find out that there is
no replacement available and conclude "the writers of this document
must have been on crack, or this document is unmaintained". I cannot
disagree with them.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
