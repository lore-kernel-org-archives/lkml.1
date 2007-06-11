Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbXFKWJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbXFKWJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbXFKWJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:09:34 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:56596 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbXFKWJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NdWFtT4GHyV2z5N5p8iCV2mn5qD339tXHImcf3w2RQLQaHUmQdJPCxnZNEcz7ZNr76W4nISW8T6r5a3kFJskuPyj1AykngbIMABYjuL9Onmyz23loqJ//KQQVMa6rqw06SXgAGLYrxwU4FPMYczsU5LfRNm8LWjA1UOml4GMqhs=
Message-ID: <8bd0f97a0706111509s161c6287pdce612946194d87@mail.gmail.com>
Date: Mon, 11 Jun 2007 18:09:32 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
Cc: "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
In-Reply-To: <20070609191010.GB11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46695F6D.5050600@t-online.de> <20070609191010.GB11166@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/07, Matt Mackall <mpm@selenic.com> wrote:
> On Fri, Jun 08, 2007 at 03:53:49PM +0200, Bernd Schmidt wrote:
> > 2. It is no longer possible to get blocks smaller than a page through
> >    mmap.  This behaviour was used by simplemalloc, which is an insane
> >    way of implementing malloc on nommu systems and hopefully not used
> >    by anyone anymore.
>
> That's worrisome. Breaking existing apps/libraries seems like a bad
> idea.

it isnt breaking anything ... simplemalloc() will continue to execute
in newer kernels
-mike
