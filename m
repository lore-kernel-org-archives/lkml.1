Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbYILWDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbYILWDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYILWC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:02:58 -0400
Received: from ozlabs.org ([203.10.76.45]:45443 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbYILWC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:02:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [RFC] CPUMASK: proposal for replacing cpumask_t
Date: Sat, 13 Sep 2008 08:02:59 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <200809121455.02180.rusty@rustcorp.com.au> <48CA7CA8.2000107@sgi.com>
In-Reply-To: <48CA7CA8.2000107@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809130803.00563.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 September 2008 00:28:56 Mike Travis wrote:
> Rusty Russell wrote:
> > I'm yet to be convinced that we really need to allocate cpumasks in any
> > fast paths.  And if not, we should simply allocate them everywhere.  I'd
> > rather see one #ifdef around a place where we can show a perf issue.
>
> Using a typedef came from Linus, and the idea is basically if NR_CPUS fits
> into a long, then it's carried as an array of one (ie., local variable).

Sure it's clever.  ie. nice and confusing.

But do we have any code paths where we care?  Unless we do, let's just keep it 
simple...

Cheers,
Rusty.

