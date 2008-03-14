Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbYCNBk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbYCNBk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYCNBkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:40:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943AbYCNBkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:40:16 -0400
Date: Thu, 13 Mar 2008 18:39:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5-git3: Reported regressions from 2.6.24
In-Reply-To: <87bq5i3xce.fsf@saeurebad.de>
Message-ID: <alpine.LFD.1.00.0803131838340.3557@woody.linux-foundation.org>
References: <200803140136.38549.rjw@sisk.pl> <87bq5i3xce.fsf@saeurebad.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Mar 2008, Johannes Weiner wrote:
> 
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10164
> > Subject		: ntfs build failure on no-mmu
> > Submitter	: Mike Frysinger <vapier.adi@gmail.com>
> > Date		: 2008-03-03 11:05 (11 days old)
> > References	: http://lkml.org/lkml/2008/3/1/179
> 
> I found this: http://lkml.org/lkml/2008/3/13/6

Fixed slightly differently in mainline by Paul Mindt in commit 
0738c4bb8f2a8bf15178f852494643b0981f578b ("nommu: Provide 
is_vmalloc_addr() stub.")

			Linus
