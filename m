Return-Path: <linux-kernel-owner+w=401wt.eu-S1761691AbXHABf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691AbXHABf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761683AbXHABew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:34:52 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:54911 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761181AbXHABeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CJ3laGeLmFk8o0HaGwn+WchYoCv6dRhcHALIMNwQ6W0cRqHM9Slq+qhUHGZWiRpZoJogeDKctqgXpqSgDlrTE0sfOtN2yJzPJOkubYX2i1bpDBUK2RIWuulX91sBHvTua0PrPGoBXFRe/HVzRaIUosuJrBVVOHoHsx1PYlljM8s=
Message-ID: <6b01c6170707311834o27a72f8cpebf65cb65c2f2d1f@mail.gmail.com>
Date: Tue, 31 Jul 2007 18:34:49 -0700
From: "Yasha Okshtein" <flyashi@gmail.com>
Reply-To: flyashi@gmail.com
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
Cc: "Andreas Schwab" <schwab@suse.de>, "Len Brown" <lenb@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Thomas Renninger" <trenn@suse.de>
In-Reply-To: <46AAF709.9060407@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707251238.50218.lenb@kernel.org> <46A98FF9.8060801@l4x.org>
	 <je8x91flu9.fsf@sykes.suse.de> <46AAF709.9060407@l4x.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/07, Jan Dittmer <jdi@l4x.org> wrote:
> Andreas Schwab wrote:
> > Jan Dittmer <jdi@l4x.org> writes:
> >> Len Brown wrote:
> >> FATAL: drivers/acpi/button: sizeof(struct acpi_device_id)=20 is not a modulo of the size of section __mod_acpi_device_table=144.
> > Are you cross-compiling?  The definition of kernel_ulong_t won't work on
> > x86.
> Yes, sorry, should have mentioned that. Build system is x86. Still,
> it didn't happen before the recent acpi merge.

I also have the same error, which I didn't have in 2.6.22:

FATAL: drivers/acpi/ac: sizeof(struct acpi_device_id)=20 is not a
modulo of the size of section __mod_acpi_device_table=48.
Fix definition of struct acpi_device_id in mod_devicetable.h
make[1]: *** [__modpost] Error 1

Build system is x86_64. I'm not cross-compiling, as the target machine
(not the build machine) is also x86_64.

 - Yasha
