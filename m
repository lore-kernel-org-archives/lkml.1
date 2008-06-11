Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYFKLFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYFKLFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 07:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYFKLFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 07:05:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1881 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754614AbYFKLF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 07:05:27 -0400
Date: Wed, 11 Jun 2008 12:51:51 +0200
From: Pavel Machek <pavel@suse.cz>
To: Barry Kasindorf <barry.kasindorf@amd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver: Setup routines
Message-ID: <20080611105151.GE5612@ucw.cz>
References: <20080609175030.2844.77365.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609175030.2844.77365.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patchset supports the new profiling hardware available in the latest AMD CPUs in the oProfile driver.

> @@ -419,9 +454,15 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>  			break;
>  		case 0x10:
>  			model = &op_athlon_spec;
> -			cpu_type = "x86-64/family10";
> +			cpu_type = "x86-64/family10h";
> +			break;

Is this string visible to userspace?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
