Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYGATc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYGATc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYGATcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:32:18 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51287 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbYGATcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:32:17 -0400
Date: Tue, 1 Jul 2008 21:32:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Avi Kivity <avi@qumranet.com>, linux-arch@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [2.6 patch] remove dummy asm/kvm.h files
Message-ID: <20080701193236.GB10350@uranus.ravnborg.org>
References: <20080701162716.GB32598@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701162716.GB32598@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 07:27:16PM +0300, Adrian Bunk wrote:
> This patch removes the dummy asm/kvm.h files on architectures not (yet) 
> supporting KVM and uses the same conditional headers installation as
> already used for a.out.h .
> 
> Also removed are superfluous install rules in the s390 and x86 Kbuild 
> files (they are already in Kbuild.asm).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

I really do not like the way we implement these checks and
think this should be a kconfig option.
But we do not (yet) require a configured kernel when exporting
to userspace so this is not feasible right now.

So despite the above this patch has my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

Same for the asm/a.out patch you posted the other day.

David - I assume you take these via your tree?

	Sam
