Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbYICM6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbYICM6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYICM6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:58:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:59360 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632AbYICM63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:58:29 -0400
Subject: Re: [PATCH 1/2] utrace core
From: Petr Tesarik <ptesarik@suse.cz>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080826220157.397C7154233@magilla.localdomain>
References: <20080826220102.89635154233@magilla.localdomain>
	 <20080826220157.397C7154233@magilla.localdomain>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Wed, 03 Sep 2008 14:58:27 +0200
Message-Id: <1220446707.6041.27.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 15:01 -0700, Roland McGrath wrote: 
> [...]
> +menuconfig UTRACE
> +	bool "Infrastructure for tracing and debugging user processes"
> +	depends on EXPERIMENTAL
> +	depends on HAVE_ARCH_TRACEHOOK
> +	depends on MODULES

Why does it depend on MODULES? Does this mean that when ptrace is
switched to using the utrace engines, non-modular kernels will have to
lack ptrace(2)?

Is there anything in the code that actually breaks without
CONFIG_MODULES?

Regards,
Petr Tesarik


