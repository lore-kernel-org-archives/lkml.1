Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbYCaC1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbYCaC1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbYCaC10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:27:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:25232 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbYCaC1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gGM5o44jvtpzfQ/9hnaby48KTO4m/jQlBbzS4YAFf6FhyC2pVaxKmA6Rna1vvxpRX8DekMRG9sH/YThHWXzq7/ob2vw2wWxbfsYnVvY7xrQPq9zHHKPYbOLs4herv7as+ClNMJejdR5rBa9Rbkw672XDNGu4NRL6BlEuAOKpdMc=
Message-ID: <86802c440803301927g42e6d8a2lf357bd5400fefc46@mail.gmail.com>
Date: Sun, 30 Mar 2008 19:27:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Steiner" <steiner@sgi.com>
Subject: Re: [PATCH 8/8] x86_64: Support for new UV apic
Cc: "Andi Kleen" <ak@suse.de>, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080331022323.GD20619@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080328191216.GA16455@sgi.com>
	 <86802c440803301622j2874ca56t51b52a54920a233b@mail.gmail.com>
	 <20080331020613.GA20619@sgi.com>
	 <86802c440803301913n1cd4fe88v2374a8ba835153e@mail.gmail.com>
	 <20080331022323.GD20619@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 7:23 PM, Jack Steiner <steiner@sgi.com> wrote:
>
> On Sun, Mar 30, 2008 at 07:13:42PM -0700, Yinghai Lu wrote:
>  > On Sun, Mar 30, 2008 at 7:06 PM, Jack Steiner <steiner@sgi.com> wrote:
>  > > > so this is "the new one of Friday"?
>  > >
>  > >  Yes, and it has the same bug although it is located
>  > >  in a slightly different place.
>  > >
>  > >  A few minutes ago, I posted a patch to delete the extra lines.
>  > >
>  > >
>  > >
>  > >  > Did you test it on non UV_X2APIC box?
>  > >
>  > >  The code is clearly wrong.  I booted on an 8p AMD box and
>  > >  had no problems. Apparently the kernel (at least basic booting) is
>  > >  not too sensitive to incorrect apicids being returned. Most
>  > >  critical-to-boot code must use apicids from the ACPI tables.
>  > >  However, the bug does affect numa node assignment. And probably
>  > >  other places, too.
>  >
>  > please consider one global get_apic_id() and bad_apicid to replace
>  > GET_APIC_ID and BAD_APICID at this point.
>
>  I think that makes sense.
>
>  The x2apic patch that should be posted in the near future also makes
>  significant changes in this area.  Once that patch is posted, I'll
>  make the simplifications.
>
>  Ok???

good.

with the x2apic patch, GET_APIC_ID is read_apic_id, and it will not shift again?

YH
