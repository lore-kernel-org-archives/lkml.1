Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbXEPTxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbXEPTxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762309AbXEPTxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:53:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:23845 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761427AbXEPTxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mjGHUohtu3aAktdPfN9mHyFOIqXMyBd4TEl+qCTPz75I2CvNAM6/mdVBRAfFk/kQIaNI9SYYRd9P2YMqh87g9sfE6bXyqsWIk3i0aTXHZRk0X9YcFfw+EhCR1VbNN9pIx4Xq63FYPylVwGjJpi/Zgj2hAYVcjlLBHAjv3RSkecc=
Message-ID: <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com>
Date: Wed, 16 May 2007 20:53:13 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Prakash Punnoor" <prakash@punnoor.de>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States driver
Cc: "Joshua Hoblitt" <jhoblitt@ifa.hawaii.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Dave Jones" <davej@redhat.com>,
       "Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <200705162039.02379.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070516011711.GE15763@ifa.hawaii.edu>
	 <200705162039.02379.prakash@punnoor.de>
X-Google-Sender-Auth: 9d1f0648ab30039f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/07, Prakash Punnoor <prakash@punnoor.de> wrote:
> Maybe you want to give a hint in the p states driver help text?

I think a hint is the right thing to do, but in the PowerNow! driver
rather than the p states one. How about adding something like this to
the X86_POWERNOW_K8 (and X86_POWERNOW_K7?) help text:

"ACPI support is required for non-UP systems and requires ACPI_PROCESSOR
 to be selected. If ACPI_PROCESSOR is compiled as a module then this
 option must be too in order for ACPI support to be available."

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
