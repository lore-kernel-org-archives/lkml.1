Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbXC1N7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbXC1N7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXC1N7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:59:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXC1N7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:59:15 -0400
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-aio@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: remove bare user-triggerable error printk
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <20070327224401.17758.17852.sendpatchset@tetsuo.zabbo.net>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Wed, 28 Mar 2007 09:58:54 -0400
In-Reply-To: <20070327224401.17758.17852.sendpatchset@tetsuo.zabbo.net> (Zach Brown's message of "Tue, 27 Mar 2007 15:44:01 -0700 (PDT)")
Message-ID: <x49zm5x4ggx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

==> On Tue, 27 Mar 2007 15:44:01 -0700 (PDT), Zach Brown <zach.brown@oracle.com> said:

Zach> aio: remove bare user-triggerable error printk The user can
Zach> generate console output if they cause do_mmap() to fail during
Zach> sys_io_setup().  This was seen in a regression test that does
Zach> exactly that by spinning calling mmap() until it gets -ENOMEM
Zach> before calling io_setup().

Zach> We don't need this printk all, just remove it.

ACK.

Zach> Signed-off-by: Zach Brown <zach.brown@oracle.com> ---

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>


-Jeff
