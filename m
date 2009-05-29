Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbZE2ODn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbZE2ODn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZE2ODg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:03:36 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:34432 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754821AbZE2ODg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:03:36 -0400
Date: Fri, 29 May 2009 10:03:09 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>, mpm@selenic.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: remove bootmem calling
In-Reply-To: <1243588044.15371.10.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0905291002070.17436@gentwo.org>
References: <1243517365.11533.65.camel@penberg-laptop>  <4A1F3724.8050103@kernel.org>  <4A1F37DD.5030800@kernel.org> <1243588044.15371.10.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009, Pekka Enberg wrote:

> Not that I am aware of. Where do you need that? This one looks ok to me
> as page allocator obviously returns PAGE_SIZE aligned chunks.

The page allocator returns PAGE_SIZE << order aligned chunks. This should
be ok.


