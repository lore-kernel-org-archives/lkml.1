Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZEDOZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZEDOZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZEDOY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:24:57 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:47876 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZEDOY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:24:57 -0400
Date: Mon, 4 May 2009 10:13:34 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
In-Reply-To: <20090504141256.GK4173@lenovo>
Message-ID: <alpine.DEB.1.10.0905041011200.17937@qirst.com>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu> <20090504131638.GJ4173@lenovo> <alpine.DEB.1.10.0905040940490.9553@qirst.com> <20090504141256.GK4173@lenovo>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Cyrill Gorcunov wrote:

> As I see page allocator already quite modified in -mm tree.
> Christoph will kmalloc with (__GFP_NOFAIL | __GFP_REPEAT)
> inform us on exhausted memory? Or we just stuck with blank
> screen instead (not blank actually but with previous messages)?

If you do not specify __GFP_NOWARN then it should give you messages,

Guess we need to very that it behaves in the right wya.

