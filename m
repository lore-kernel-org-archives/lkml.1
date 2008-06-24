Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbYFXLxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbYFXLxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYFXLw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:52:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:58751 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbYFXLw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Yx4QGIQsMVV7M96iY55Cr4V7Y+/WIWa2FOfi9agdmm/CqKTgA4HRZjT29fN/iIs2ds
         ZWu5UZZvI9fKdH12MlybO3YLhxL2apSg3TSTO6CFFYpai8D2RHG9uC5NCtF/IzJNE7xi
         lnFgjduvri9blOlbnIb/HPR5GQUbAD0Xv9LIE=
Message-ID: <19f34abd0806240452w2561040uc2b1b1d35562db71@mail.gmail.com>
Date: Tue, 24 Jun 2008 13:52:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
Cc: "Len Brown" <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Zhao Yakui" <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>
In-Reply-To: <20080624114139.GC21890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080620135639.GA5073@damson.getinternet.no>
	 <alpine.LFD.1.10.0806201458500.3027@localhost.localdomain>
	 <19f34abd0806201340t502ce471n578dd2498a5f1992@mail.gmail.com>
	 <19f34abd0806201427h740ca3e7gc2f01c7e34616fd4@mail.gmail.com>
	 <19f34abd0806210119o64a1c9ban78710651a01530cf@mail.gmail.com>
	 <20080624114139.GC21890@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/08, Ingo Molnar <mingo@elte.hu> wrote:
> i havent seen the warning reappear with your fix after thousands of
> bootups - so i guess we can consider it fixed.
>
> Len, please consider the patch below. (it's in tip/out-of-tree)

No, please don't :-)

It fixes your particular case (the acpi_rtc_init() hunk of the patch),
but the acpi_walk_namespace() part should be changed to a WARN(). But
that is likely to cause a lot of "spurious" reports, so the other acpi
drivers should be fixed as well.

I was waiting for Len to reply, but maybe I can submit the proper fix too.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
