Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbYD3PWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbYD3PWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYD3PWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:22:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35835 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbYD3PWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:22:39 -0400
Date: Tue, 29 Apr 2008 10:22:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Problems with -git14
Message-ID: <20080429102207.7f20f63c@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0804301516580.30549@blonde.site>
References: <20080430015655.5a42f63d@werewolf.home>
	<Pine.LNX.4.64.0804301516580.30549@blonde.site>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 16:17:46 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> One point worth noting - is it a worry?  Prior to that smpboot merge,
> my Xeon booted the two HT siblings on one physical first, then the
> two siblings on the other physical after - when i386, but alternated
> them when x86_64.  Since the merge, the x86_64 sequence is unchanged,
> but the i386 sequence is now like x86_64.  I prefer this consistency,
> and I prefer the new sequence: booting with maxcpus=2 then uses the
> independent physicals without HT sharing; but surprises in store?
> 

this is how it always was supposed to be!
At least this is how Intel specifies it to the BIOS vendors (but remember, it's the bios
that pretty much sets the cpu order; some will be weird).

Exactly for the maxcpus=2 reason... (and for systems where the cpu scheduler does 
load balancing "from 0 up" it also makes sense)
