Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbXLCOHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbXLCOHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 09:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXLCOHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 09:07:36 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:25422 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbXLCOHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:07:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=el6wfe8HS/1IfMbSzjGY8XsVkNGCJ+1SkRbpXbJ7O8JiNklvj4SRpxURsJ3z9MX4viJbIB2LUj8+fNRRs1fNdDBd7WaRx7R90WmTn4hGIvDURwMAwaB04HfPUtKCgjXyogtxLSO2mLxZ/KIYu4suWN4V0wDPLYmGpGUkWpE9Yy8=
Message-ID: <84144f020712030607v79ebf1e8w8c8b14d2647f1deb@mail.gmail.com>
Date: Mon, 3 Dec 2007 16:07:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
Cc: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>, acme@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071203135700.GR15974@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp>
	 <20071202134841.GI15974@stusta.de>
	 <200712030634.CBJ18798.OVFQJSFFOHMtLO@I-love.SAKURA.ne.jp>
	 <20071202214629.GA15034@ghostprotocols.net>
	 <200712032041.ABB90643.SOFVQFtMHFLOOJ@I-love.SAKURA.ne.jp>
	 <20071203135700.GR15974@stusta.de>
X-Google-Sender-Auth: 125e67fe6f538cb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 03, 2007 at 08:41:44PM +0900, Tetsuo Handa wrote:
> > We couldn't know how much memory was allocated by kmalloc() in 2.4 era, and we can know it 2.6 era.
> > But are we going back to 2.4 era for out-of-tree kernel modules?

On Dec 3, 2007 3:57 PM, Adrian Bunk <bunk@kernel.org> wrote:
> The interesting fact is that there are zero in-kernel modules using it.

Yeah, and now that we have krealloc() I don't expect that many callers
actually need ksize() either.

                                Pekka
