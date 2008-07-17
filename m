Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbYGQSHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbYGQSHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbYGQSHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:07:42 -0400
Received: from ag-out-0708.google.com ([72.14.246.243]:61240 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781AbYGQSHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=qjRoMtSfhGg59kWM/GS+Y5VIuRY52OVXbQJanN9sRERHWztsFlxrnGcZ4gvHyWatj3
         ypc45Ng07CA5J6PhMQTWul5lYhqbPSqL1I3gtzUb9ceUd4VKaW3cIbJGH69qIsApZpYe
         BzFgDpVHI3h54EbUc0WKDVKyfY2Vp/rWulGcU=
Date: Thu, 17 Jul 2008 21:06:16 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] kmemtrace: SLUB hooks.
Message-ID: <20080717180615.GA5360@localhost>
References: <cover.1216255034.git.eduard.munteanu@linux360.ro> <017a63e6be64502c36ede4733f0cc4e5ede75db2.1216255035.git.eduard.munteanu@linux360.ro> <84144f020807170046j2fae2f41k7c80dba4e388677b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020807170046j2fae2f41k7c80dba4e388677b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 10:46:51AM +0300, Pekka Enberg wrote:
> On Thu, Jul 17, 2008 at 3:46 AM, Eduard - Gabriel Munteanu
> <eduard.munteanu@linux360.ro> wrote:
> > This adds hooks for the SLUB allocator, to allow tracing with kmemtrace.
> >
> > Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > ---
> >  include/linux/slub_def.h |    9 +++++++-
> >  mm/slub.c                |   47 ++++++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 49 insertions(+), 7 deletions(-)
> 
> What are these casts doing here? I think you can just drop them, no?

Yes, I should cut all these casts off. Will resubmit soon.


	Eduard

