Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYGSLUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYGSLUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 07:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYGSLUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 07:20:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47418 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYGSLUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 07:20:32 -0400
Subject: Re: [PATCH] slub: dump more data on slab corruption
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org
In-Reply-To: <20080718202646.GE24122@elte.hu>
References: <Pine.LNX.4.64.0807181729370.7723@sbz-30.cs.Helsinki.FI>
	 <20080718202646.GE24122@elte.hu>
Date: Sat, 19 Jul 2008 14:20:15 +0300
Message-Id: <1216466415.6762.160.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 22:26 +0200, Ingo Molnar wrote:
> * Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > The limit to 128 bytes is too small when debugging slab corruption of the skb
> > cache, for example. Increase the limit to PAGE_SIZE to make debugging
> > corruptions sligthly easier.
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Applied, thanks!

