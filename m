Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZGAVyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZGAVyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZGAVxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:53:51 -0400
Received: from outbound-mail-27.bluehost.com ([69.89.17.193]:50737 "HELO
	outbound-mail-27.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752811AbZGAVxu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:53:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZnherNvjpzrLGwfB30jy4CJ6089JrU+A600gSNos4fzxk+KilRHhXWJKGkwzGsc1+zpmNmPtxx7lyR77DnX6beAjzxzKeD3QgG9U4nkDO/TjSsz9tV0KEmILT+mEdzkQ;
Date: Wed, 1 Jul 2009 14:53:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2] Add a driver for the Winbond WPCD376I IR
 functionality.
Message-ID: <20090701145351.78c0f28b@jbarnes-g45>
In-Reply-To: <20090701214753.GB5946@hardeman.nu>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu>
	<1246079912-17619-3-git-send-email-david@hardeman.nu>
	<20090630142345.58e97b50.akpm@linux-foundation.org>
	<20090701214753.GB5946@hardeman.nu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 23:47:53 +0200
David Härdeman <david@hardeman.nu> wrote:

> This patch adds a driver for the the Consumer IR (CIR) functionality
> of the Winbond WPCD376I chipset (found on e.g. Intel DG45FC
> motherboards).
> 
> Changes since the driver was first posted to the list:
> o Homebrew dprintk -> dev_dbg
> o Some magic values changed to defines
> o Fixed a bug where the wake-ir-command mask/value would not be
>    written properly
> o Fixed the use of the invert parameter both for wake and normal
>    IR reception.
> 
> Changes since the second post to the list (AKPM's remarks):
> o Various comments added
> o Removed some casts
> o use bitrev8
> o convert data->irdata to unsigned longs, use __set_bit and test_bit
> 
> Andrew, please replace the patch you currently have in the -mm tree
> with this one.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>

Looking nice to me...  Thanks for writing this, David.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
