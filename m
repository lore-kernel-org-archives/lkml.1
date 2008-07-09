Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYGIVXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYGIVXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbYGIVWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:22:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49445 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbYGIVWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:22:46 -0400
Message-ID: <48752A93.5020500@zytor.com>
Date: Wed, 09 Jul 2008 17:16:03 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <487522A8.60906@zytor.com>	<48752409.1030201@goop.org> <m1abgqu5rg.fsf@frodo.ebiederm.org>
In-Reply-To: <m1abgqu5rg.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> But we can pick an arbitrary point where %gs points at.
> 
> Hmm.  This whole thing is even sillier then I thought.
> Why can't we access per cpu vars as:
> %gs:(per_cpu__var - __per_cpu_start) ?
> 
> If we can subtract constants and allow the linker to perform that resolution
> at link.  A zero based per cpu segment becomes a moot issue.
> 

And then we're back here again!

Supposedly the linker buggers up, although we don't have conclusive 
evidence...

	-hpa

