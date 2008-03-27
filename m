Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYC0QKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYC0QKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbYC0QKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:10:41 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:41123 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395AbYC0QKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nMc9+YUR3Y2NxERFi9GNJDh+mnbIKUr7ZoGkYu7dIck2Z7/C6bCsa4Uc7vcbrBYsgRa1ZidS2wQNTFyqXJxtX2iAI5LjKWAmcemOIZnWn8sunt0AJbItdlC9/dIZ9gypyEqLYNYHNBMqg6dUd0mGjrtEQ6tNt2SBqY6NhL9Gw/I=
Message-ID: <86802c440803270910q6602606aode3c355bf7947d32@mail.gmail.com>
Date: Thu, 27 Mar 2008 09:10:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86/pci: add pci=skip_isa_align command lines.
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Gary Hade" <garyhade@us.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080327084557.GH15626@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803270131.18885.yhlu.kernel@gmail.com>
	 <20080327084557.GH15626@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 1:45 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>  > [PATCH] x86/pci: add pci=skip_isa_align command lines.
>  >
>  > so we don't align the io port start address for pci cards.
>  >
>  > also move out dmi check out acpi.c, because it has nothing to do with
>  > acpi. it could spare some calling when we have several peer root
>  > buses.
>
>  i like this feature, and i've applied your patch to x86.git for testing,
>  but i'd like to hear what the ACPI and PCI guys think about this.
>
>  Also, we should try as hard as possible to make it a blacklist instead
>  of a whitelist? It would be cool to support more PCI cards/devices on
>  all new(-ish) systems by default and if we didnt have to maintain the
>  DMI whitelist for eternity. (a whitelist will always be incomplete and
>  will lag behind reality)

yeah, blacklist is more good. that limitation is quite old...

YH
