Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYK0Ww7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYK0Ww7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 17:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYK0Wwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 17:52:50 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:44959 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYK0Wwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 17:52:49 -0500
Date: Thu, 27 Nov 2008 16:51:28 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Hugh Dickins <hugh@veritas.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
 at ffff8800be8b0019
In-Reply-To: <Pine.LNX.4.64.0811272136260.1747@blonde.site>
Message-ID: <Pine.LNX.4.64.0811271647450.16124@quilx.com>
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com> 
 <200811270026.37941.rjw@sisk.pl>  <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
  <Pine.LNX.4.64.0811271349040.21910@blonde.site>
 <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
 <Pine.LNX.4.64.0811271643250.9618@blonde.site> <492F0FEB.50805@cs.helsinki.fi>
 <Pine.LNX.4.64.0811272136260.1747@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Hugh Dickins wrote:

> If we assume that, then why does KSYM_NAME_LEN allow 128?  I'll agree
> that 128 seems rather on the high side (I'd abhor symbols of anywhere
> near that length in any code I came near), but that's what's allowed,
> so shouldn't SLUB be going along with that?

Your fix looks fine. The maximum symbol length needs to be supported by
list_locations() althought a line with a symbol like that would look a bit
weird.


