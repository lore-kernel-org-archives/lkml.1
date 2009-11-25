Return-Path: <linux-kernel-owner+w=401wt.eu-S935013AbZKYUTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013AbZKYUTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934984AbZKYUTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:19:40 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:44171 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934983AbZKYUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:19:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=a/xnKwuD0Iw/V+jDod5ofSizFzjkmmx4ZyOAujY0YGm1sLnBdnDGRZg1hALdfN4eg1
         AkqrXivN6ctIQMygttzU+EH0Gq+QQ38av537zOuSLCavobxWYU5++N9uFiZuvXyRQEJQ
         QiLxsmUEIDawURvz8tXvkJyPWTaJ8KO1cxwz0=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0911251414480.4779@router.home>
References: <1259173279-21220-1-git-send-email-penberg@cs.helsinki.fi>
	 <1259173636.29779.41.camel@Joe-Laptop.home>
	 <4B0D77CC.3020807@cs.helsinki.fi>
	 <alpine.DEB.2.00.0911251414480.4779@router.home>
Date: Wed, 25 Nov 2009 22:19:44 +0200
X-Google-Sender-Auth: c5f16941d93b547b
Message-ID: <84144f020911251219lb60a4c5s618b791a50824958@mail.gmail.com>
Subject: Re: [PATCH] SLUB: Fix __GFP_ZERO unlikely() annotation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 10:15 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Wed, 25 Nov 2009, Pekka Enberg wrote:
>
>> Because that has no effect on the generated code.
>
> Does this affect the cycle count in slab_alloc?

Joe's suggestion doesn't change the generated code, my patch does and
probably changes cycle count. Let me see if I can run the in-kernel
slab tests.
