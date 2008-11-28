Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYK1Hzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYK1Hzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 02:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYK1HzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 02:55:21 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60316 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbYK1HzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 02:55:20 -0500
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
	at ffff8800be8b0019
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0811271647450.16124@quilx.com>
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>
	 <200811270026.37941.rjw@sisk.pl>
	 <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
	 <Pine.LNX.4.64.0811271349040.21910@blonde.site>
	 <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
	 <Pine.LNX.4.64.0811271643250.9618@blonde.site>
	 <492F0FEB.50805@cs.helsinki.fi>
	 <Pine.LNX.4.64.0811272136260.1747@blonde.site>
	 <Pine.LNX.4.64.0811271647450.16124@quilx.com>
Date: Fri, 28 Nov 2008 09:57:06 +0200
Message-Id: <1227859026.6039.4.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 16:51 -0600, Christoph Lameter wrote:
> On Thu, 27 Nov 2008, Hugh Dickins wrote:
> 
> > If we assume that, then why does KSYM_NAME_LEN allow 128?  I'll agree
> > that 128 seems rather on the high side (I'd abhor symbols of anywhere
> > near that length in any code I came near), but that's what's allowed,
> > so shouldn't SLUB be going along with that?
> 
> Your fix looks fine. The maximum symbol length needs to be supported by
> list_locations() althought a line with a symbol like that would look a bit
> weird.

Yup,

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

