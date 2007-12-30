Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbXL3Vxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbXL3Vxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXL3Vxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:53:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:30864 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbXL3Vxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:53:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GEyrdYhQx1i1e6FiIsaZzWH17tjWCSeQAflIL7ZnZ4NSptfqE5WV7s9os1DXoyczaZQbAm2H1oOLrxADGE+8pGdht1Z5R5fZoJ3Mjh0UBH0opttiFHf0k5wDbL0uStiZF4onJrdaRy/b8jjDZbVJWFqP5thQW5x/L2TMRXyNpJY=
Message-ID: <86802c440712301353w4ced46ffg8919328ff1576d1e@mail.gmail.com>
Date: Sun, 30 Dec 2007 13:53:35 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86_64: fix section warning about enable_IO_APIC and setup_local_APIC
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071230212945.GA14654@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712291952.20455.yinghai.lu@sun.com>
	 <20071230145115.GR16946@elte.hu>
	 <200712301330.19396.yinghai.lu@sun.com>
	 <20071230212945.GA14654@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 1:29 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
> > [PATCH] x86_64: fix section warning about enable_IO_APIC and setup_local_APIC
> >
> > clear IO_APIC before enabing apic error vector cause link warning
> >
> > use function call in setup_local_APIC to avoid that.
>
> as i said, this just works around the link warning - now we've traded
> the link warning for a runtime crash.

you got one runtime crash by this fix?

YH
