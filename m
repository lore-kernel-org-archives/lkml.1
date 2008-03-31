Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYCaLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYCaLnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYCaLnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:43:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54572 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYCaLnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:43:08 -0400
Date: Mon, 31 Mar 2008 13:46:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       arjan@linux.intel.com, thomas@tungstengraphics.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
Message-ID: <20080331114646.GE29105@one.firstfloor.org>
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <21d7e9970803310421k67f1a697s8ffb5a4eef71c605@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970803310421k67f1a697s8ffb5a4eef71c605@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 09:21:19PM +1000, Dave Airlie wrote:
> On Mon, Mar 31, 2008 at 5:25 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Dave Airlie <airlied@redhat.com> writes:
> >  >
> >  > +#define CPA_FLUSHTLB 1
> >  > +#define CPA_ARRAY 2
> >
> >  I don't think CPA_ARRAY should be a separate case. Rather single
> >  page flushing should be an array with only a single entry. pageattr
> >  is already very complex, no need to make add more special cases.
> 
> I thought about this but the current interface takes a start address
> and number of pages from that point to cpa,
> the array interface takes an array of page sized pages.
> 
> I don't really think we need to generate an array in the first case
> with all the pages in it..

Just put the length into the array members too.

-Andi
