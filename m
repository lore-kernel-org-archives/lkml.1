Return-Path: <linux-kernel-owner+w=401wt.eu-S1761325AbYFGOcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325AbYFGOcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYFGObz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:31:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:25876 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbYFGObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DI0xnXpIjOieQs/bSgsBo6FmCSTh82fhADNJV07bs++iPJp7o2PPoOmyV7cXJWp2Z+
         18R5tyKT2N1c0FIke2AJeiubgXUoazkKUPDmhd8QGlSs/YvkPu6cHF6ykAHcgEkb88aE
         Tj7UL5SegIeOWtstjUXyx3U28G8ugXXut2NwM=
Message-ID: <3d8471ca0806070731o98d62a9lab6caf394aa60277@mail.gmail.com>
Date: Sat, 7 Jun 2008 16:31:50 +0200
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Justin Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>
In-Reply-To: <200806071359.04426.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806062321x2918f6feq7c817bde52ba0c4c@mail.gmail.com>
	 <20080606235526.783acc83.akpm@linux-foundation.org>
	 <200806071359.04426.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 12:59 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> I also noticed that in -git volume wheel behaves strangely, it sometimes increases volume
> when I rotate it in direction of decrease, and vise versa.

I have a similar problem, the ACPI keys on my laptop are very laggy
(like 1 second), maybe you are seeing the same thing with your volume
wheel?

changing
 if (atomic_read(&ec->irq_count) > 5) {
 to
if (atomic_read(&ec->irq_count) > 20) {
fixed the problem completely for me.

It's all in http://bugzilla.kernel.org/show_bug.cgi?id=9998

Cheers.

-- 
Guillaume
