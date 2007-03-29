Return-Path: <linux-kernel-owner+w=401wt.eu-S1030619AbXC2SLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030619AbXC2SLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030622AbXC2SLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:11:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:52313 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030619AbXC2SLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:11:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K7TAkTYBcDNdA5JkVJJrkjYVqoNONqK7jUYnKlSbaREK668uyTdwexuI4mWVnPNBQhkXsQgY+wKCiA3MltkEWhMWfza6NPtYHqUYPiWcIkJLQ+9oUqeUYfuglrLJ5WWqN3CVeW7hcN/rLuYKapvwu7yehFWRq0oVpHe4FXPSt44=
Message-ID: <b6a2187b0703291111k67fcc904u8a225cbee8cf3e58@mail.gmail.com>
Date: Fri, 30 Mar 2007 02:11:47 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [PATCH v2] Add suspend/resume for HPET
Cc: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Jens Axboe" <jens.axboe@oracle.com>, "Len Brown" <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, "Michael S. Tsirkin" <mst@mellanox.co.il>
In-Reply-To: <200703291546.48996.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <460BBD1B.4040308@ru.mvista.com>
	 <200703291531.18253.maximlevitsky@gmail.com>
	 <200703291546.48996.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Subject: Add suspend/resume for HPET
> This adds support of suspend/resume on i386 for HPET
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

Confirmed that suspend/resume disk/ram works on X60s with
CONFIG_HPET_TIMER=y and CONFIG_NO_HZ unset.

But suspend to disk still hang with CONFIG_NO_HZ unset.

Thanks,
Jeff.
