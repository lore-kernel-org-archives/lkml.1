Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYBOWLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYBOWLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbYBOWLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:11:40 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:22586 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbYBOWLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:11:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fFYn6kgs1ey8wOHU0UiL+pwTZKv7YnvbJ2kHS3OCCp7xm+sgpXwpmNZXXm6FO8X06EwW5IjylZr5vwkrIaimZPGBRNuzP492i4LRR4NdrNBQ7wRJIgtWKP3pvwUFdarLDzx3+Ht9fzIktubfM9aguUEoekZ0cyALekZXd4Xh3PE=
Message-ID: <86802c440802151411k40dfc711g4965410bba11dc33@mail.gmail.com>
Date: Fri, 15 Feb 2008 14:11:37 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 1/5] x86: validate against acpi motherboard resources
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <p7363wq1nk2.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802150127.21247.yinghai.lu@sun.com>
	 <p7363wq1nk2.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 3:11 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
>  >
>  > [akpm@linux-foundation.org: many fixes and cleanups]
>  > Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>  > Signed-off-by: Andi Kleen <ak@suse.de>
>  > Tested-by: Andi Kleen <ak@suse.de>
>
>  iirc it really was
>  Tested-and-didnt-pass-test-by: Andi Kleen
>  unfortunately. I have not rechecked recently, but on the one Intel
>  box the original patch and the other mcfg heuristics removed didn't work.

it seems some intel system with old bios need

PATCH: Fix boot-time hang on G31/G33 PC

but greg decided not to use it, and user need to update BIOS or use pci=nommconf

but this one
x86: validate against acpi motherboard resources

should be different. it just reveres the BIOS bug.

Ingo,
Can you remove the line regarding Andi, and put them into x86 mm?

Andi could use pci=nommconf with that system with buggy BIOS or update the BIOS

YH
