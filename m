Return-Path: <linux-kernel-owner+w=401wt.eu-S938106AbXHHSko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938106AbXHHSko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761334AbXHHSkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:40:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:53819 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbXHHSkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iNZ9D8Q4XgNoHUaTPRNWTePTTyov2dXMuTtd+54vnnVJapZL/U8JWbO4rNvXvTHryxXDQJpnZDnRztOVqFH+IJ62gt49HHhyNdyC5vJPDlByeX4ViB88R1bP7ZrUaDTQVFa+XEr3HWFemZcOtaNBnn7B7r1m1XGJGKoaQGv3af8=
Message-ID: <29495f1d0708081140s5b8c2cc8xcf929f1aad9c0530@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:40:31 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: jschopp <jschopp@austin.ibm.com>
Subject: Re: Make checkpatch warn about pointless casting of kalloc returns.
Cc: "Dave Jones" <davej@redhat.com>, apw@shadowen.org, rdunlap@xenotime.net,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <46BA0B28.4090404@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070808024321.GA6316@redhat.com>
	 <46B9F7C9.9060406@austin.ibm.com> <20070808180056.GF26440@redhat.com>
	 <46BA0B28.4090404@austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, jschopp <jschopp@austin.ibm.com> wrote:
> >  > > +                        WARN("No need to cast return value.\n");
> >  >
> >  > Could the warning be more descriptive?  This describes what, but it should also describe
> >  > why; after all if somebody made this error they may not know they why.
> >
> > I'm open to suggestions..
>
> How about
>
> WARN("No need to cast return value, it is unnecessary and can hide real bugs.  See
> http://c-faq.com/malloc/mallocnocast.html for more details\n");

That's a long line. Can it be split into two? Otherwise seems sane.

Thanks,
Nish
