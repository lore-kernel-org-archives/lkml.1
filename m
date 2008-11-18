Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbYKRM1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbYKRM1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 07:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYKRM0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 07:26:53 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:33957 "EHLO mail.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752027AbYKRM0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 07:26:52 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2008 07:26:51 EST
Date: Tue, 18 Nov 2008 12:16:20 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hitoshi Mitake <h.mitake@gmail.com>, Hitoshi Mitake <mitake@clustcom.com>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, ktaka@clustcom.com,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-ID: <20081118121620.GB8625@linux-mips.org>
References: <20081105222911.d76e7e1c.mitake@clustcom.com> <413709.12821.qm@web50106.mail.re2.yahoo.com> <20081106164641.ed369060.akpm@linux-foundation.org> <20081107152830.a42766f3.mitake@clustcom.com> <20081106223122.8a255211.akpm@linux-foundation.org> <20081107153824.0ec934e6.mitake@clustcom.com> <20081106231102.aab83cd4.akpm@linux-foundation.org> <a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com> <20081109112646.97c594b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109112646.97c594b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 11:26:46AM -0800, Andrew Morton wrote:

> Perhaps it would be better to have a CONFIG_ARCH_HAS_READQ and to then
> disable these drivers on the architectures which don't provide
> readq/writeq support.

And we also need to define the exact semantics.  Questions coming to mind:

  o are implementations performing 2 32-bit accesses acceptable?
  o if so, what ordering for the two accesses is acceptable?

  Ralf
