Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYEPHCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYEPHCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYEPHCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:02:04 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42403 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbYEPHCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:02:01 -0400
Date: Fri, 16 May 2008 09:01:57 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: make michael_block a function
Message-ID: <20080516070157.GA9769@Chamillionaire.breakpoint.cc>
References: <1210918637.5915.24.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1210918637.5915.24.camel@brick>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Harvey Harrison | 2008-05-15 23:17:17 [-0700]:

>Make the michael_block macro a function and change the calling
>function to take a struct michael_mic_ctx * and the value for
>the initial xor with ctx->l.
>
>Also open-code xswap in its one use in michael_block.
Does this change have any performance impact?
The only user is wireless (I guess). Is it used frequently (sign every
packet for instance) or once in a while (in every re-keying)?

Sebastian
