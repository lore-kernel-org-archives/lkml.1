Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbYHDWDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbYHDWDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbYHDWCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:02:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:11126 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbYHDWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xal2RHp37jqTAHnERXzua8c7D0v5z3V4Qh4ONTIl4JokQ9d6i+Hw02fU9VipACANax
         pm+It1j/1T7sHM5542cV62L1dIHUmjariaH26DQMVrnNiN5oOpED5PBaG67XMzm12NnA
         zOk2g35ooyh3956z5/hBZkbZtPoOLBJW0FLj0=
Date: Tue, 5 Aug 2008 02:02:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: detach SLUB_DEBUG and SYSFS
Message-ID: <20080804220247.GA10159@martell.zuzino.mipt.ru>
References: <20080801000405.GA7072@martell.zuzino.mipt.ru> <48941C2F.8010406@cs.helsinki.fi> <489702B9.5030204@linux-foundation.org> <48970DDD.4040607@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48970DDD.4040607@cs.helsinki.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 05:10:37PM +0300, Pekka Enberg wrote:
> Christoph Lameter wrote:
>> Pekka Enberg wrote:
>>> Alexey Dobriyan wrote:
>>>> Right now, SYSFS=n means no SLUB debugging, no even basic poisoning,
>>>> to hell with tunables.
>>> Applied, thanks!
>> Do not apply. This partially reverts an earlier commit and would cause 
>> build
>> issues because the #ifdef parts in slub.c were not reverted.
>
> Aww, crap. OK, taking it out.

OK, I'll test-compile it to death.

For now, do you agree that SYSFS=n users shouldn't be discriminated
against poisoning?

As real world situation, NET_NS feature which is currently in
active development doesn't work with SYSFS, so it was a bit of cold
shower to realise that I did much testing of conntracking in netns
without poisoning. :-(

