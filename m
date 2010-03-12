Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab0CLSkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 13:40:55 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:38187 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0CLSky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 13:40:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o5AjTTKDqKHEmBdaZFD2PDHP/h8MgRra7mYg13uoPEskVOJVc2XQnnWig2zRw91h4O
         ny+pYL/bqGUpM0UONipTdgTxX5BPiROKoIsqpeK4CQ7hiD7mwJ2MnpH0uGi8+SeTUswC
         MBoL79yQX0NJ3JiiO7Xh2Oo+xxyPd9ldQjxc0=
Date: Fri, 12 Mar 2010 20:40:56 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ext-phil.2.carmody@nokia.com
Subject: Re: [PATCH] err.h: add __must_check to error pointer handlers
Message-ID: <20100312184056.GA4107@x200>
References: <1268401540-8994-1-git-send-email-ext-jani.1.nikula@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268401540-8994-1-git-send-email-ext-jani.1.nikula@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 03:45:40PM +0200, Jani Nikula wrote:
> Add __must_check to error pointer handlers to have the compiler warn
> about mistakes like:
> 
> 	if (err)
> 		ERR_PTR(err);

> -static inline void *ERR_PTR(long error)
> +static inline void * __must_check ERR_PTR(long error)

We had bugs like that?

Pretty much every non-void function should be marked then.
