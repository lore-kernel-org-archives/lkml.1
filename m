Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbYGKAVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbYGKAVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbYGKAUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:20:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36705 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbYGKAUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:20:45 -0400
Message-ID: <4876A5CA.7020109@zytor.com>
Date: Thu, 10 Jul 2008 20:14:02 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com> <487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org> <48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org> <48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <487639ED.7000502@zytor.com> <48763CA6.9030802@linux-foundation.org> <487647EF.5010609@goop.org> <48764A01.1070402@linux-foundation.org> <48764C7C.5010309@goop.org> <48767692.4080504@linux-foundation.org> <487677F0.4000404@goop.org> <4876799B.7010204@linux-foundation.org> <48767F4F.1010209@zytor.com> <4876A56C.3050707@sgi.com>
In-Reply-To: <4876A56C.3050707@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> Hmm, that might be the way to go.... At boot up time determine the
> size of the system in terms of cpu count and memory available and
> attempt to do the right thing, with startup options to override the
> internal choices... ?
> 
> (Surely a system that has a "gazillion ip tunnels" could modify it's
> kernel start options... ;-)
> 
> Unfortunately, we can't use a MODULE to support different options unless
> we change how the kernel starts up (would need to mount the root fs
> before starting secondary cpus.)
> 

Using a module doesn't make any sense anyway.  This is more what the 
kernel command line is for.

	-hpa
