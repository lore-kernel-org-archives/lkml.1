Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbXDFRGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbXDFRGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933363AbXDFRGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:06:49 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:50752 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933367AbXDFRGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:06:48 -0400
Date: Fri, 6 Apr 2007 19:06:40 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Martin Bligh <mbligh@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leave loglevel at 7 through sysrq output so you can
 actually read it
In-Reply-To: <4616765C.3050509@google.com>
Message-ID: <Pine.LNX.4.64.0704061903360.14457@scrub.home>
References: <46157DD2.4050502@google.com> <Pine.LNX.4.64.0704061830401.14458@scrub.home>
 <4616765C.3050509@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 6 Apr 2007, Martin Bligh wrote:

> > I think you have to tell sysrq_handle_loglevel() about this too...
> 
> Not sure why? That just changes the current loglevel, and seems
> unaffected.

Who's the last to set console_loglevel?

> I did test the patch, and it works fine.

Did you check /proc/sys/kernel/printk?

bye, Roman
