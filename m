Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYAWAFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYAWAFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbYAWAFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:05:30 -0500
Received: from mail2.neteffect.com ([204.57.75.68]:55685 "EHLO
	mail2.neteffect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534AbYAWAF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:05:29 -0500
X-Greylist: delayed 973 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2008 19:05:29 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [ofa-general] Re: InfiniBand/RDMA merge plans for 2.6.25
Date: Tue, 22 Jan 2008 17:49:12 -0600
Message-ID: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FEA2@venom2>
In-Reply-To: <adad4rttthr.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] Re: InfiniBand/RDMA merge plans for 2.6.25
Thread-Index: AchdQZdAoADd0jrLRdSIaI2p3ofoEwADI1TA
From: "Glenn Streiff" <gstreiff@NetEffect.com>
To: "Roland Dreier" <rdreier@cisco.com>,
       "Christoph Hellwig" <hch@infradead.org>
Cc: <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: general-bounces@lists.openfabrics.org
> [mailto:general-bounces@lists.openfabrics.org]On Behalf Of 
> Roland Dreier
> Sent: Tuesday, January 22, 2008 3:56 PM
> To: Christoph Hellwig
> Cc: linux-kernel@vger.kernel.org; general@lists.openfabrics.org
> Subject: [ofa-general] Re: InfiniBand/RDMA merge plans for 2.6.25
> 
> 
>  > >  - Neteffect "nes" driver.  It's not terribly clean code 
> but since
>  > >    it's a new driver that is completely self-contained, I plan on
>  > >    merging it and letting cleanups happen upstream.
>  > 
>  > New code should be better quality than old code, not 
> worse.   I haven't
>  > actually seen the driver yet, but by that statement I'd be clearly
>  > against a merge.
> 
> The driver has been posted a few times; the latest code is in the
> "neteffect" branch of my tree:
> 
>     
> git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniban
> d.git neteffect
> 
> It's not *that* bad -- certainly there are lots of things that could
> be improved (sparse endianness annotation, too many lines that are way
> to long, strange indentation of case labeles, etc, etc) but it is a
> self-contained hardware driver.  I agree with Linus's position (stated
> at the last kernel summit) that we ought to merge hardware drivers
> early, so that users get the drivers with as little hassle as
> possible.  We lose a little leverage in getting cleanups done, but the
> number of people who see the code and are able to clean it up
> increases, so I think it's a good trade-off.
> 
>  - R.
> 

My view is the code should and will be cleaned up based upon
the feedback we've gotten from the community.  It is a priority
for me.

Several cleanup fixes are in the queue and are being worked.
Haven't slipped into complacency at the prospect of the merge.

Glenn
gstreiff@neteffect.com
