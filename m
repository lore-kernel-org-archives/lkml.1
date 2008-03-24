Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbYCXRj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbYCXRj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760647AbYCXRje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:39:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:13038 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760477AbYCXRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:39:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mMoHqY1FCvxSRIbylUbplxjtZn6GFlh+rM4OWNaYY7CwANVce+lFXvorjxe5yb1nZ2SsuvMx2Xr4/XpzovTkD/Lsh6c2T+QyOezS0tTrDrO/qigPaHgqG1xputHdcLjNZq8F6tcDTnAGx1tsLcvrYK5u5dg+G8AL+X8X4laiIK8=
Message-ID: <4cefeab80803241039n829edeexa141089c40a08a57@mail.gmail.com>
Date: Mon, 24 Mar 2008 23:09:33 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
Subject: Re: [PATCH 2/6] compcache: block device - internal defs
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <200803241725.59726.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242033.30782.nitingupta910@gmail.com>
	 <200803241725.59726.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 9:55 PM, Mariusz Kozlowski
<m.kozlowski@tuxland.pl> wrote:
> Hi Nitin,
>
>
>  >  +#define K(x)   ((x) >> 10)
>  >  +#define KB(x)  ((x) << 10)
>
>  Hm. These look cryptic unless you remember what they do.
>  Could have better names?

I'll give them better names/add comments.

>
>
>  > +#define CC_DEBUG2((fmt,arg...) \
>  > +       printk(KERN_DEBUG C fmt,##arg)
>
>  Unbalanced parenthesis.
>

Corrected. Thanks.

- Nitin

>  Just my 0.05zl.
>
>         Mariusz
>
