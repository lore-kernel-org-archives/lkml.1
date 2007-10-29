Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbXJ2UUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbXJ2UUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbXJ2UUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:20:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:34559 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbXJ2UUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=thw0k0TdI9J4ap2MsD6/2MayoPTdv3XJi6dSwaq3415K7Fj3cYmX9WjWUKlIKaejP63aMP5esFKDoQCHszZJcuC1qZXSt3czxgUMBGQnHnP+yKcGTJQsoZyBFcZrTZp9p89UMLAw6s+Z3HQ++ZoCUtJ4klblbZPdJv0reQI/87A=
Message-ID: <aa79d98a0710291320r5412ebcboc90234cc2ac56102@mail.gmail.com>
Date: Mon, 29 Oct 2007 23:20:28 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH] Clean up scatterlist.h and introduce macros for readability.
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071029185803.GA7499@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710291234560.20259@localhost.localdomain>
	 <20071029185803.GA7499@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could you please give a link to that explanation? It seems I've missed
it somehow. Thanks.

On 10/29/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Oct 29 2007, Robert P. J. Day wrote:
> >
> > Add some macros to <linux/scatterlist.h> to make the bit manipulation
> > more readable, and expand on some of the documentation.
> >
> > This patch incorporates content from Cyrill Gorcunov
> > <gorcunov@gmail.com> as well.
>
> I don't like it, I already explained why I don't consider the 'magic'
> values a problem. The use of the bits is supposed to be scatterlist.h
> private and the values are documented at the top of that include file.
>
> --
> Jens Axboe
>
>
