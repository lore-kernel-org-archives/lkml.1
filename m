Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZBPQca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZBPQca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZBPQcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:32:22 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3375 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZBPQcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:32:21 -0500
Subject: Re: [PATCH] Export symbol ksize()
From: Joe Perches <joe@perches.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-crypto@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Geert.Uytterhoeven@sonycom.com
In-Reply-To: <20090216135643.GA6927@cmpxchg.org>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
	 <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
	 <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>
	 <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
	 <20090216135643.GA6927@cmpxchg.org>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 08:32:32 -0800
Message-Id: <1234801952.20430.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 14:56 +0100, Johannes Weiner wrote:
> One problem is that zeroing ksize()
> bytes can have an overhead of nearly twice the actual allocation size.

A possible good thing is when linux has a
mechanism to use known zeroed memory in
kzalloc or kcalloc, it's already good to go.

