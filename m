Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbXH3OCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbXH3OCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbXH3OCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:02:01 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:29335 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbXH3OCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hpdppS/SQSVqAjNzmPodjqVw8Ejvf2D9f0UcBp7DjVWyAsJ2jDtC3FVFveHQ+Gohxe32Ukzq3CoJhw+mWltVAceUGckVFG6RKW5hDi+7dqmsi4FRXWLukC/UjYJubyZOR/BNfz07kgdqWkUV3V3mn2fP0eNlvSov/mUXeBrqzhY=
Message-ID: <8bd0f97a0708300701r1f36bc0anc45b9cad4a11f2ef@mail.gmail.com>
Date: Thu, 30 Aug 2007 10:01:59 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/07, Jiri Kosina <jkosina@suse.cz> wrote:
> From: Jiri Kosina <jkosina@suse.cz>
>
> i386 and x86_64: randomize brk()
>
> This patch randomizes the location of the heap (brk) for i386 and x86_64.
> The range is randomized in the range starting at current brk location up
> to 0x02000000 offset for both architectures. This, together with
> pie-executable-randomization.patch and
> pie-executable-randomization-fix.patch, should make the address space
> randomization on i386 and x86_64 complete.
>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

does it really make sense to stick stubs into no-mmu ports which
cannot utilize the ELF binfmt ?
-mike
