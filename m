Return-Path: <linux-kernel-owner+w=401wt.eu-S1751068AbXBJNuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbXBJNuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 08:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXBJNuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 08:50:09 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:44482 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXBJNuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 08:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sa/7aRl82gHj3dVq9n5xJsnEd+Xn6zEqwBVg8fFwKnWcDJSN2FVgeM8PDFXR4ynjjkSGcMEHAHfV78iebVcjjAbNbyf4J2HxWf6qam58drggiQNbprboUNfK5x1Q8V+ujy7cv6bew9TJrKy0lO/LBmZS0g9amJgayzEcifrhvFo=
Message-ID: <82e4877d0702100550ld369c8an2982a64dcc920169@mail.gmail.com>
Date: Sat, 10 Feb 2007 08:50:06 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] Make aout executables work again
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       joerg@hydrops.han.de, dsd@gentoo.org, paulus@samba.org,
       benh@kernel.crashing.org, lethal@linux-sh.org
In-Reply-To: <p73y7n6goey.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702092100540.3984@localhost.localdomain>
	 <p73y7n6goey.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I already fixed this in a different way -- just use the stack
> trampoline on a.out
>
> Can you double check
>
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/aout-no-vdso
>
> works for you?

Is there a reason why we specifically want to make a distinction
between binfmts having and not having VDSOs and do we want aout to
have the possibility of NOT having VDSO when a) It used to have it
unconditionally b) nothing special is needed in arch or common code to
have it and c) Not letting have it requires special arch-specific
code* ?


[*] I see the patch handles i386 and x86_64 - but I am not sure if
something similar will be needed for the other arches to allow aout
executables in absence of VDSO (powerpc, sh).

Parag
