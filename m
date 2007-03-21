Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbXCUOlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbXCUOlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXCUOlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:41:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:59557 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbXCUOlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DERWLhCMjrialAvT0jQoaTYVO92fMZ0prb7KIXL50SlOpVsfOzdAY+gIwxZ45DX/37j7tU5oAZZ8cNUssGAdqSa3l1+00nFd09ynBIx8i/1HiqacS/ynVwhoF1KMMkvac28hmUkIXhEBv8mMJ89UPnGoWmsy/aC/T37r3gLqEr0=
Message-ID: <84144f020703210741g4b6b2000kf19b439a4c42f445@mail.gmail.com>
Date: Wed, 21 Mar 2007 16:41:19 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Cc: "Jarek Poplawski" <jarkao2@o2.pl>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, mpm@selenic.com,
       "Christoph Lameter" <clameter@sgi.com>, "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200703211511.10342.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI>
	 <20070321133151.GC1939@ff.dom.local>
	 <Pine.LNX.4.64.0703211531450.16596@sbz-30.cs.Helsinki.FI>
	 <200703211511.10342.rjw@sisk.pl>
X-Google-Sender-Auth: c2821d7c70ac1fe0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> IMHO one way to find them is to actually slow down kmem_cache_free() and see
> where the performance is hurt.

Yeah, I'll try to sneak a patch past Andrew.
