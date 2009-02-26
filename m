Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZBZIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZBZIQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZBZIQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:16:15 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:56459 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZBZIQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:16:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y8ayDNjyRoG9m7+mILOTdXRdWpRNwjEj3fXnOWLq4ZIp/hf+kYPiQ3s03ai9AvOAOC
         G7UHoCpKy6eeMFg4YFQosvJ712/gUMINukF6uyOLFtGt6jJSq+FKDAjVW2YKuuLypAQp
         RApHWknD20XgHEpqWbRJMxcL4dZiKjWbvLRtI=
MIME-Version: 1.0
In-Reply-To: <1235632643.5465.0.camel@penberg-laptop>
References: <1235381712.6216.22.camel@penberg-laptop>
	 <alpine.DEB.1.10.0902231039580.7298@qirst.com>
	 <1235410406.6216.69.camel@penberg-laptop>
	 <19f34abd0902251117h7a4a6e9ao34e972110d8b40a1@mail.gmail.com>
	 <alpine.DEB.1.10.0902251622460.13795@qirst.com>
	 <1235632643.5465.0.camel@penberg-laptop>
Date: Thu, 26 Feb 2009 09:16:10 +0100
Message-ID: <19f34abd0902260016x1b354583o418d5f77fe51ae4e@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: Disable SLUB and SLAB debugging when kmemcheck 
	is enabled
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/26 Pekka Enberg <penberg@cs.helsinki.fi>:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> Date: Mon, 23 Feb 2009 11:35:13 +0200
> Subject: [PATCH] kmemcheck: Disable SLUB and SLAB debugging when kmemcheck is enabled
>
> Enabling kmemcheck in Kconfig is a painful experience. Lets make it a
> tad bit easier by inverting the dependencies to SLUB and SLAB debugging.
> As kmemcheck is more powerful than slab debugging, disable the latter
> functionality if an user enables kmemcheck.
>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Thanks, applied!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
