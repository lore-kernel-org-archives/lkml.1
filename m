Return-Path: <linux-kernel-owner+w=401wt.eu-S1161829AbXECKwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161829AbXECKwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161831AbXECKwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:52:35 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1780 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161829AbXECKwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:52:34 -0400
Date: Thu, 3 May 2007 12:52:32 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rename thread_info to stack
In-Reply-To: <20070502212721.5883abbc.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705031234000.1479@scrub.home>
References: <Pine.LNX.4.64.0705010210010.1479@scrub.home>
 <20070502212721.5883abbc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2 May 2007, Andrew Morton wrote:

> On Tue, 1 May 2007 02:10:34 +0200 (CEST) Roman Zippel <zippel@linux-m68k.org> wrote:
> 
> > This finally renames the thread_info field in task structure to stack,
> > so that the assumptions about this field are gone and archs have more
> > freedom about placing the thread_info structure.
> 
> It's been a year or so and I've forgotten what the actual point to these
> changes is.  Can we be reminded please?

Nonbroken archs which have a proper thread pointer can do the access to 
both current thread and task structure via a single pointer.
It'll allow for a few more cleanups of the fork code, from which e.g. ia64 
could benefit.

bye, Roman
