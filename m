Return-Path: <linux-kernel-owner+w=401wt.eu-S932551AbYAaDM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbYAaDM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760920AbYAaDMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:12:17 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51716 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbYAaDMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:12:15 -0500
Date: Wed, 30 Jan 2008 19:29:39 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: PATCH] x86_64: make bootmap_start page align v4
In-reply-to: <200801310402.14912.ak@suse.de>
To: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801301929.40463.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
 <200801301215.51645.yinghai.lu@sun.com> <200801310402.14912.ak@suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008 07:02:14 pm Andi Kleen wrote:
> 
> > I don't think so, that is setup_node_bootmem's problem.
> >
> > it is supposed to round_up instead of just do PAGE_SHIFT...
> >
> > other caller will just use the address instead change it page.
> 
> You're right. In this case it really is the best way to round up in the 
> caller. I retract my earlier objection.
> 
> That said there is not really any true requirement for the bootmem
> map to be page aligned (AFAIK) so an alternative might be to 
> fix the bootmem interface to not take a PFN. But that would be a 
> much more intrusive patch because you would need to fix 
> other architectures too or add compat wrappers.

thanks.

So we need to v4.

Ingo,

can you apply the v4?

YH
