Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbXIYEUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbXIYEUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbXIYEUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:20:22 -0400
Received: from ozlabs.org ([203.10.76.45]:36249 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbXIYEUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:20:21 -0400
Subject: Re: [PATCH 1/3] Virtualization config cleanup: Select
	CONFIG_PARAVIRT when required
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>, Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070925040537.GL6800@stusta.de>
References: <1190692688.27805.276.camel@localhost.localdomain>
	 <20070925040537.GL6800@stusta.de>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 14:20:03 +1000
Message-Id: <1190694003.27805.291.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 06:05 +0200, Adrian Bunk wrote:
> depends on !(X86_VISWS || X86_VOYAGER)

Hmm, if A selects B and B depends on C, does A not depend on C?

If not, I'll patch this...

Thanks,
Rusty.


