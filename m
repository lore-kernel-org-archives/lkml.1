Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZCLLbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZCLLbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZCLLav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:30:51 -0400
Received: from mail2.shareable.org ([80.68.89.115]:52106 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZCLLau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:30:50 -0400
Date: Thu, 12 Mar 2009 11:29:53 +0000
From: Jamie Lokier <jamie@shareable.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, peterz@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] RE: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Message-ID: <20090312112953.GD6995@shareable.org>
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk> <20090311170840.2f136849.akpm@linux-foundation.org> <5DC5324CE00E4D4494EE5F031E354E9501CE9C0F@BUDMLVEM03.e2k.ad.ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5DC5324CE00E4D4494EE5F031E354E9501CE9C0F@BUDMLVEM03.e2k.ad.ge.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Berkhan, Enrik (GE Infra, Oil & Gas) wrote:
> Andrew Morton wrote:
> > On Wed, 11 Mar 2009 15:30:35 +0000
> > David Howells <dhowells@redhat.com> wrote:
> >> From: Enrik Berkhan <Enrik.Berkhan@ge.com>
> >> 
> >> The solution is to mark the pages dirty at the point of allocation by
> >> the truncation code.
> > 
> > Was there a specific reason for using the low-level SetPageDirty()?
> 
> No, no specific reason. It was just my first try of a fix after spotting 
> the problem. After a short discussion with David, we decided to wait for 
> others' comments on using the low-/high-level approach.

Tangentially related...

Does the vm pageout logic include or skip these "dirty" pages looking
for candidates to flush to storage?  What about with MMU?

-- Jamie
