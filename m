Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab0CJOea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:34:30 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:41175 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0CJOe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:34:28 -0500
Date: Wed, 10 Mar 2010 08:33:06 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       roland@redhat.com, peterz@infradead.org
Subject: Re: 2.6.34-rc1: kernel BUG at mm/slab.c:2989!
In-Reply-To: <4B977282.40505@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1003100832200.17615@router.home>
References: <2375c9f91003100029q7d64bbf7xce15eee97f7e2190@mail.gmail.com> <4B977282.40505@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Pekka Enberg wrote:

> > Please let me know if you need more info.
>
> Looks like regular SLAB corruption bug to me. Can you trigget it with SLUB?

Run SLUB with CONFIG_SLUB_DEBUG_ON or specify slub_debug on the kernel
command line to have all allocations checked.

