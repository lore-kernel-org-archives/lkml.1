Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYCJRXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYCJRXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYCJRXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:23:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52682 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYCJRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:23:44 -0400
Date: Mon, 10 Mar 2008 18:25:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080310172533.GB7692@one.firstfloor.org>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu> <20080309114640.85c9c3eb.akpm@linux-foundation.org> <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com> <87myp68r88.fsf@basil.nowhere.org> <Pine.LNX.4.64.0803101707070.3398@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803101707070.3398@blonde.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 05:19:32PM +0000, Hugh Dickins wrote:
> On Mon, 10 Mar 2008, Andi Kleen wrote:
> > Christoph Lameter <clameter@sgi.com> writes:
> > > 
> > > Zeroed pages however will not address the issue of having initialized pgd 
> > > (which seems to be what i386 needs).
> > 
> > pgd is tiny on i386 PAE (4 * 16 bytes). Are you sure reinitializing that
> > is a serious issue? ...
> 
> It used to be tiny (32 aligned bytes), then 2.6.22's quicklist enlarged
> that to a whole (lowmem) page.  I think we were all too busy with other
> stuff to protest loudly enough about that bloat.

Interesting; I missed.

Hmm, that might have been for Xen or Vmware too (which like some structures
be page aligned) But I agree it is bloat in general.

-Andi
