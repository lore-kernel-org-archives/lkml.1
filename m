Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZGPNzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZGPNzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbZGPNzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:55:14 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:33304 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755619AbZGPNzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:55:13 -0400
Date: Thu, 16 Jul 2009 09:54:49 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set
 V2
In-Reply-To: <20090716163537.9D3D.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907160949470.32382@gentwo.org>
References: <alpine.DEB.1.10.0907151027410.23643@gentwo.org> <20090715220445.GA1823@cmpxchg.org> <20090716163537.9D3D.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, KOSAKI Motohiro wrote:

> I like this patch. but can you please separate two following patches?
>   - introduce __TESTCLEARFLAG()
>   - non-atomic test-clear of PG_mlocked on free

That would mean introducing the macro without any use case? It is fine the
way it is I think.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
