Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXC3WaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXC3WaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932725AbXC3WaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:30:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:25830 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbXC3WaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WYMBOxI4zsAA1AemG/PIbMpvqz0szz+m2rol50CnXGcF8iZwG/5cft3kgrmCCsEj7cP6FpjhI1VEAueeMOOogPkpAhxFozkapIslQbZHjduBz15VTgrwWv+kveRPa5tbxdmFsz+Zn2fQ92wpAFjsNgl3/Z4H/j61n8j5eQga4/Y=
Message-ID: <a44ae5cd0703301530i8c5fa51n767538d78065dca7@mail.gmail.com>
Date: Fri, 30 Mar 2007 15:30:10 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: 2.6.21-rc5-mm2 -- ACPI problems (lid switch broken, always shows running from AC, plugging in AC hangs machine)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <200703301410.43857.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0703281355h13f1bd70s9eb94092bfa9c3e@mail.gmail.com>
	 <a44ae5cd0703291335q1eff6661hf398dfca1db8e491@mail.gmail.com>
	 <a44ae5cd0703291449p1e8f75a2i68e9874362cef061@mail.gmail.com>
	 <200703301410.43857.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, Len Brown <lenb@kernel.org> wrote:
> On Thursday 29 March 2007 17:49, Miles Lane wrote:
> > Hmm.   I've reproduced these problems with vanilla 2.6.21-rc5, so the
> > latest acpi-git changes are off the hook....
>
> I think the 1st message on this thread holds the answer:
>
> > ACPI: BIOS bug: multiple APIC/MADT found, using 2
> > ACPI: If "acpi_apic_instance=0" works better, notify linux-acpi@vger.kernel.org
>
> Looking at your acpidump in
> http://bugzilla.kernel.org/show_bug.cgi?id=8283
> clearly the 2nd table is broken (it is missing the SCI override)
> and that is why you get no ACPI interrupts.
>
> If Windows works on your machine -- ACPI events such as power button etc --
> then that is proof that Windows doesn't use the 2nd MADT and I need
> to revert 09fe58356d148ff66901ddf639e725ca1a48a0af

Yes, the patch you sent fixes these problems.

Thanks!
       Miles
