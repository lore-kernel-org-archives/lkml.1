Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbYKRMde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbYKRMde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 07:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYKRMdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 07:33:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56947 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYKRMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 07:33:24 -0500
Date: Tue, 18 Nov 2008 12:32:15 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hitoshi Mitake <h.mitake@gmail.com>,
       Hitoshi Mitake <mitake@clustcom.com>, Doug Thompson <norsk5@yahoo.com>,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       ktaka@clustcom.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-ID: <20081118123215.GB30509@flint.arm.linux.org.uk>
Mail-Followup-To: Ralf Baechle <ralf@linux-mips.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hitoshi Mitake <h.mitake@gmail.com>,
	Hitoshi Mitake <mitake@clustcom.com>,
	Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
	linux-kernel@vger.kernel.org, ktaka@clustcom.com,
	linux-arch@vger.kernel.org
References: <20081105222911.d76e7e1c.mitake@clustcom.com> <413709.12821.qm@web50106.mail.re2.yahoo.com> <20081106164641.ed369060.akpm@linux-foundation.org> <20081107152830.a42766f3.mitake@clustcom.com> <20081106223122.8a255211.akpm@linux-foundation.org> <20081107153824.0ec934e6.mitake@clustcom.com> <20081106231102.aab83cd4.akpm@linux-foundation.org> <a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com> <20081109112646.97c594b5.akpm@linux-foundation.org> <20081118121620.GB8625@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118121620.GB8625@linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 12:16:20PM +0000, Ralf Baechle wrote:
> On Sun, Nov 09, 2008 at 11:26:46AM -0800, Andrew Morton wrote:
> 
> > Perhaps it would be better to have a CONFIG_ARCH_HAS_READQ and to then
> > disable these drivers on the architectures which don't provide
> > readq/writeq support.
> 
> And we also need to define the exact semantics.  Questions coming to mind:
> 
>   o are implementations performing 2 32-bit accesses acceptable?
>   o if so, what ordering for the two accesses is acceptable?

and don't forget to document the semantics.  If we're going to end up
with CONFIG_ARCH_HAS_READQ which architectures can select, I suggest
putting it in the help for that symbol.  Why not another random file
in Documentation/ ?  Because it's a random file in Documentation/
that'll be overlooked when someone decided to select ARCH_HAS_READQ.
If it's along side the relevent config option, there is a higher
chance it will be noticed.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
