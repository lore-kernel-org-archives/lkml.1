Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbXDFQbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbXDFQbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXDFQbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:31:39 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:50708 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068AbXDFQbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:31:38 -0400
Date: Fri, 6 Apr 2007 18:31:26 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Martin Bligh <mbligh@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leave loglevel at 7 through sysrq output so you can
 actually read it
In-Reply-To: <46157DD2.4050502@google.com>
Message-ID: <Pine.LNX.4.64.0704061830401.14458@scrub.home>
References: <46157DD2.4050502@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Apr 2007, Martin Bligh wrote:

> We carefully set loglevel to 7, and print the sysrq messsage
> as to what event we're doing, but we can't actually see
> the output as it sets it back before calling the handler,
> rather than after.
> 
> Move the assignment down one line.

I think you have to tell sysrq_handle_loglevel() about this too...

bye, Roman
