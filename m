Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbXHEP1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbXHEP1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbXHEP10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:27:26 -0400
Received: from ag-out-0708.google.com ([72.14.246.250]:15507 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbXHEP1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RIhc6JT2U5bcPK787JEdNEgKdA25ptJAoCMLakDB7F5kSZYM6ENEehUQhFVydPCI+fqV3ylMZzTXvZ5C9qZmcI2v971W9d9mNocC4mO6QsOJdrzSGj+R8BIsjnKMX/nqW2dI32Ke7CL3kLpwHZSG8dKi4a1XRdAfQBfZLKQqZtM=
Message-ID: <9a8748490708050827p71e2abc1o9e29a87b76194d32@mail.gmail.com>
Date: Sun, 5 Aug 2007 17:27:24 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH][RESEND] efficeon-agp leaks 'struct agp_bridge_data' in error paths of agp_efficeon_probe()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Carlos Puchol" <cpglinux@puchol.com>, hpa@transmeta.com,
       "David Airlie" <airlied@linux.ie>
In-Reply-To: <46B54D76.6060300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708042030.58259.jesper.juhl@gmail.com>
	 <46B54D76.6060300@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Jesper Juhl wrote:
> > (This is a resend of a patch originally submitted on 24-Jul-2007 00:14)
> >
> >
> > Ok, this is something the coverity checker found (CID: 1813).
> > I'm not at all intimate with this code, so I'm not sure if this
> > attempt at a fix is correct (but at least it compiles).
> >
> > Please look it over and NACK if bad or merge if good ;-)
> >
>
> Looks sensible to me.
>
Good. Thank you for taking a look.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
