Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbXGPSWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbXGPSWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXGPSWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:22:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:46654 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbXGPSWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:22:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ZnS/1qOGv0ojfoDoxBuI+8nUQgwk2vmFyl9+I1fcjs7S7rjS3CVDqPx1xToHJy+Kv
	+992X2Qgssj1ldZhx07JQ==
Message-ID: <8f95bb250707161122q33e2c1afo9dd5fa2b3b97988e@mail.gmail.com>
Date: Mon, 16 Jul 2007 11:22:13 -0700
From: "Aaron Durbin" <adurbin@google.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] ACPI: Add reboot mechanism
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com, ak@suse.de, akpm@osdl.org
In-Reply-To: <1184609844.2698.1.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716180019.GA5112@google.com>
	 <1184609844.2698.1.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 2007-07-16 at 11:00 -0700, Aaron Durbin wrote:
> > Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.
> >
> > Signed-off-by: Aaron Durbin <adurbin@google.com>
> > ---
> >
> > diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> > index d4336f1..c9906a5 100644
> > --- a/drivers/acpi/Makefile
> > +++ b/drivers/acpi/Makefile
> > @@ -21,7 +21,7 @@ obj-$(CONFIG_X86)           += blacklist.o
> >  #
> >  # ACPI Core Subsystem (Interpreter)
> >  #
> > -obj-y                                += osl.o utils.o \
> > +obj-y                                += osl.o utils.o reboot.o \
>
> a one function C file? Can you just stick it in one of the other files
> instead?
>

I originally did not do this because I didn't know the proper place.  Any
suggestions where you would want this?

-Aaron
