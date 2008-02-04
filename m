Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYBDGjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYBDGjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 01:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYBDGjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 01:39:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:29228 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYBDGjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 01:39:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ST8Bv3ETjGEkgM2c1ZZR0128wCwARQC9/ex/abfUvtA8PnMGCPpBdC2ZYUmDqrTkM
	mPbfblNfN9r9Xe3PtUBhw==
Message-ID: <3f1a065b0802032239t251fac96p800c4c60afdb915c@mail.gmail.com>
Date: Sun, 3 Feb 2008 22:39:03 -0800
From: "Russell Leidich" <rml@google.com>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, valdis.kletnieks@vt.edu
Subject: Re: [PATCH] Remove Barcelona Thermal Throttling
In-Reply-To: <3f1a065b0802032213j713fe551t9a0642ea2b83994@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f1a065b0802032213j713fe551t9a0642ea2b83994@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P.S. This patch also moves the responsibility for enabling hardware
thermal control from the OS to the BIOS.

On Feb 3, 2008 10:13 PM, Russell Leidich <rml@google.com> wrote:
> All,
>
> You can imagine my dismay when I recently learned that, after all our
> collective effort, hardware thermal throttling does not work reliably
> on Barcelona, according to AMD.  Due to NDA restrictions, I am unable
> to provide further details.
>
> But the effort has not been a waste; whenever AMD manages to make a
> reliable hardware thermal sensor, this code should "just work" along
> with all the other northbridge initialization associated with the
> device IDs in k8_northbridges[].
>
> This patch Blacklists Barcelona as non-hardware-thermal-throttlable
> (in addition to RevF, which was already blacklisted).  On the
> recommendation of my colleagues, it also contains these politeness
> enhancements: (1) warns the user if the CPU is _not_ blacklisted, but
> the BIOS neglected to enable thermal throttling (as a safety measure)
> and (2) uses the PCI_SLOT macro instead of the more obnoxious
> shift-right-by-3 to compute PCI device numbers.
>
> This patch assumes that it is being applied _after_ my previous patch
> has already been integrated.  I mailed out that patch on 1/17/2008
> with subject "Re: [PATCH] AMD Thermal Interrupt Support".
> --
> Russell Leidich
>



-- 
Russell Leidich
