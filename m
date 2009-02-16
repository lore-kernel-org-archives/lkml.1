Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZBPSRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZBPSRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 13:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZBPSRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 13:17:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:7235 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZBPSRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 13:17:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lUfFMr6/WKJuNLCRblkUXfREIeth7GGtGkXfRGqhqJa5qlS0KTTjU0sm/Uj3zNbhI0
         kBJx2w/3nxk+CTB1VwdqYTnEvRxFkBV83zQtcDDlA4/O0URkCrjgwnqHfWwr7PrJxnRH
         Iad7APMSOXwFheGKPCvrfKb+5ubzcztHNVGL0=
MIME-Version: 1.0
In-Reply-To: <20090216153351.GB27520@cmpxchg.org>
References: <20090216142926.440561506@cmpxchg.org>
	 <20090216144725.976425091@cmpxchg.org>
	 <84144f020902160713y7341b2b4g8aa10919405ab82d@mail.gmail.com>
	 <20090216153351.GB27520@cmpxchg.org>
Date: Mon, 16 Feb 2009 20:17:31 +0200
X-Google-Sender-Auth: 67fea24e72adf24b
Message-ID: <84144f020902161017s5439a4d8ra9792250243dd43f@mail.gmail.com>
Subject: Re: [patch 6/8] cifs: use kzfree()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 5:33 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Here is the delta to fold into the above:
>
> [ btw, do these require an extra SOB?  If so:
>  Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>
>  And for http://lkml.org/lkml/2009/2/16/184:
>  Signed-off-by: Johannes Weiner <hannes@cmpxchg.org> ]

Looks good to me. As I like to see my name in the LWN stats articles,
consider the whole patch:

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
