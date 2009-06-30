Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZGAJBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZGAJBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZGAJBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:01:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58227 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbZGAJBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:01:00 -0400
Date: Tue, 30 Jun 2009 08:32:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
Message-ID: <20090630063230.GD1351@ucw.cz>
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +#define X86_PLATFORM_FEATURE_FLOPPY		(0*32+5) /* ISA floppy */
> +#define X86_PLATFORM_FEATURE_ISA		(0*32+6) /* ISA/LPC bus */
> +#define X86_PLATFORM_FEATURE_BIOS		(0*32+7) /* BIOS service,
> +							   *  e.g. int calls
> +							   *  EBDA, etc.
> +							   */
> +#define X86_PLATFORM_FEATURE_ACPI		(0*32+8) /* has ACPI support */
> +#define X86_PLATFORM_FEATURE_SFI		(0*32+9) /* has SFI support */
> +#define X86_PLATFORM_FEATURE_8042		(0*32+10) /* i8042 KBC */
> +
> +extern __u32 platform_feature[N_PLATFORM_CAPINTS];
> +extern const char *const
> +	x86_platform_available_feature[N_PLATFORM_CAPINTS * 32];
> +#define platform_has(bit) \
> +	test_bit(bit, (unsigned long *)platform_feature)

test_bit and friends imply synchronization you probably  don't want or
need...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
