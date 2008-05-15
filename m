Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbYEOAat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbYEOAat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 20:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYEOAaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 20:30:39 -0400
Received: from ozlabs.org ([203.10.76.45]:55406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbYEOAaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 20:30:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Matti Linnanvuori" <mattilinn@gmail.com>
Subject: Re: [patch] doc: add a chapter about trylock functions [Bug 9011]
Date: Thu, 15 May 2008 10:30:18 +1000
User-Agent: KMail/1.9.9
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <ca0148c30805130831h11fe0ca0qf501bd07d1141940@mail.gmail.com>
In-Reply-To: <ca0148c30805130831h11fe0ca0qf501bd07d1141940@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805151030.18959.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2008 01:31:47 Matti Linnanvuori wrote:
> +    <function>mutex_trylock()</function> does not suspend your task
> +    but returns non-zero if it could lock the mutex on the first try
> +    or 0 if not. This function cannot be safely used in hardware or
> +    software interrupt contexts despite not sleeping.

I know this is what the documentation says, but I can't see why.  Ingo?

Thanks,
Rusty.
PS. Patch fixed up and applied.
