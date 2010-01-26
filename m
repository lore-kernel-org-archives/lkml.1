Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403Ab0AZVfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0AZVfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755Ab0AZVfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:35:44 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:35194 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab0AZVfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:35:44 -0500
Date: Tue, 26 Jan 2010 15:35:33 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Matt Mackall <mpm@selenic.com>, Nigel Cunningham <ncunningham@crca.org.au>,
       Pedro Ribeiro <pedrib@gmail.com>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org >> linux-mm" <linux-mm@kvack.org>
Subject: Re: BUG at mm/slab.c:2990 with 2.6.33-rc5-tuxonice
In-Reply-To: <4B5F5794.8020302@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1001261534380.30784@router.home>
References: <74fd948d1001261121r7e6d03a4i75ce40705abed4e0@mail.gmail.com>  <4B5F52FE.5000201@crca.org.au> <1264539045.3536.1348.camel@calx> <4B5F5794.8020302@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010, Pekka Enberg wrote:

> Looks like slab corruption to me which is usually not a slab bug but caused by
> buggy callers. Is CONFIG_DEBUG_SLAB enabled?

Typical BUG for slab metadata that has been overwritten by
something.
