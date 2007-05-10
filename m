Return-Path: <linux-kernel-owner+w=401wt.eu-S1760468AbXEJKJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbXEJKJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758781AbXEJKJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:09:44 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:28334 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758951AbXEJKJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e1PjApI4tJktyYm83BvcIoCXncOgPgGZcElSK5+RnHB5MDO/tJ2o4MpwaXHFBLR97htAKb1tvlgOXltK3Rq2AtJ8RwgHyvKEL261mbTo0yIKwfFVpt3FuO4lWQ4OXttcaVnxv1/k9I9xYqGDHMk/s884cx+mB0PAHQFhNMJQBUg=
Message-ID: <ac8af0be0705100309y49d0bcf7jd055aa9fa949e29f@mail.gmail.com>
Date: Thu, 10 May 2007 18:09:42 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [discuss] A question about GART aperture unmap
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070510094908.GB14898@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0705092259p65f057bcoe5e1b9abb963d5e3@mail.gmail.com>
	 <20070510094908.GB14898@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Andi Kleen <andi@firstfloor.org> wrote:
> > After commenting out clear_kernel_mapping() line, the system would
> > have sync flood and reset from time to time. However when with this
> > clear_kernel_mapping() line, no system reset happened.
>
> Hmm, that should not happen. Normally the problems fixed by
> this are expected to be very rare and you also should not get
> sync flood, but just cache line corruption. While it might be possible
> for random corruption to then cause sync flood that should be again
> rather unlikely. If it's repeatable quickly something else
> must be wrong.

The log recorded in IPMI SEL log showed that there's a GART error:
3f01 | OEM record e0 | 1800000000f60000010005001b  GART

Forrest
