Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXKTEA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXKTEA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 23:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXKTEAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 23:00:14 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:35695 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752159AbXKTEAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 23:00:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QhlGZ5pvUEDIoIPbxY5dGLmYOjtFpJpZkRme1iG5fxX6c03mX4dWGL+bYel8tdlNlnheHgv1ULVSMtC2DjtjaI4p5yV9sig8gBD5uZuDSOIR9mSYECuEbgW2TYE7aKfsujagDD0Q+BxlvV8crWTaeC5/4Bu7Y0wMbQeCkpBZjIM=  ;
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [rfc 08/45] cpu alloc: x86 support
Date: Tue, 20 Nov 2007 14:59:12 +1100
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>, ak@suse.de, akpm@linux-foundation.org,
       travis@sgi.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <474239CA.20403@zytor.com> <Pine.LNX.4.64.0711191759370.19954@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711191759370.19954@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201459.12841.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 13:02, Christoph Lameter wrote:
> On Mon, 19 Nov 2007, H. Peter Anvin wrote:
> > You're making the assumption here that NUMA = large number of CPUs. This
> > assumption is flat-out wrong.
>
> Well maybe. Usually one gets to NUMA because the hardware gets too big to
> be handleed the UMA way.
>
> > On x86-64, most two-socket systems are still NUMA, and I would expect
> > that most distro kernels probably compile in NUMA.  However,
> > burning megabytes of memory on a two-socket dual-core system when we're
> > talking about tens of kilobytes used would be more than a wee bit insane.
>
> Yeah yea but the latencies are minimal making the NUMA logic too expensive
> for most loads ... If you put a NUMA kernel onto those then performance
> drops (I think someone measures 15-30%?)

Small socket count systems are going to increasingly be NUMA in future.
If CONFIG_NUMA hurts performance by that much on those systems, then the
kernel is broken IMO.
