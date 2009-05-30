Return-Path: <linux-kernel-owner+w=401wt.eu-S1762961AbZE3RgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762961AbZE3RgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 13:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760595AbZE3Rf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 13:35:58 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:60274 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760573AbZE3Rf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 13:35:58 -0400
Date: Sat, 30 May 2009 10:33:36 -0700
From: "Larry H." <research@subreption.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu, faith@redhat.com
Subject: Re: [patch 3/5] Apply the PG_sensitive flag to audit subsystem
Message-ID: <20090530173336.GG6535@oblivion.subreption.com>
References: <20090520185005.GC10756@oblivion.subreption.com> <alpine.LFD.2.01.0905301020260.3435@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905301020260.3435@localhost.localdomain>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:21 Sat 30 May     , Linus Torvalds wrote:
> 
> 
> On Wed, 20 May 2009, Larry H. wrote:
> >
> > +	if (!(gfp_mask & GFP_SENSITIVE))
> > +		gfp_mask |= GFP_SENSITIVE;
> 
> WTF?

Indeed.

> Why is this different from just "gfp_mask |= GFP_SENSITIVE;"

Blame anal retentiveness at the time of writing that. Surely the test
should be ditched. Looking back at that, I honestly think there might be a
place to plug the flag (in the caller) instead of doing that. I don't
think there are many places to do it, so this particular patch from the
set can be ditched and rewritten (if you want to take the selective
clearing road...)

	Larry
