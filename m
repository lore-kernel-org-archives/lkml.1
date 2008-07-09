Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYGIUse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYGIUse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbYGIUs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:48:27 -0400
Received: from gw.goop.org ([64.81.55.164]:41996 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYGIUs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:48:26 -0400
Message-ID: <48752409.1030201@goop.org>
Date: Wed, 09 Jul 2008 13:48:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu> <48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org> <4875209D.8010603@goop.org> <487522A8.60906@zytor.com>
In-Reply-To: <487522A8.60906@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Thinking about this some more, I don't know if it would make sense to 
> put the x86-64 stack canary at the *end* of the percpu area, and 
> otherwise use negative offsets.  That would make sure they were 
> readily reachable from %rip-based references from within the kernel 
> text area. 

If we can move the canary then a whole pile of options open up.  But the 
problem is that we can't.

    J

