Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZDNJyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZDNJyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZDNJyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:54:02 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:37557
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbZDNJyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:54:00 -0400
Date: Tue, 14 Apr 2009 11:53:54 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux@arm.linux.org.uk
Subject: Re: linux-next: Tree for April 14: CONFIG_OABI_COMPAT build failure
Message-ID: <20090414095354.GB15516@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux@arm.linux.org.uk
References: <20090414160809.e92d9d3e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414160809.e92d9d3e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

building of next-20090414 fails for ARM with CONFIG_OABI_COMPAT:

arch/arm/kernel/sys_oabi-compat.c: In function 'sys_oabi_epoll_wait':
arch/arm/kernel/sys_oabi-compat.c:288: error: implicit declaration of
function 'kmalloc'
arch/arm/kernel/sys_oabi-compat.c:288: error: 'GFP_KERNEL' undeclared
(first use in this function)
arch/arm/kernel/sys_oabi-compat.c:288: error: (Each undeclared
identifier is reported only once
arch/arm/kernel/sys_oabi-compat.c:288: error: for each function it
appears in.)
arch/arm/kernel/sys_oabi-compat.c:288: warning: assignment makes
pointer from integer without a cast
arch/arm/kernel/sys_oabi-compat.c:301: error: implicit declaration of
function 'kfree'
arch/arm/kernel/sys_oabi-compat.c: In function 'sys_oabi_semtimedop':
arch/arm/kernel/sys_oabi-compat.c:324: error: 'GFP_KERNEL' undeclared
(first use in this function)
arch/arm/kernel/sys_oabi-compat.c:324: warning: assignment makes
pointer from integer without a cast
make[1]: *** [arch/arm/kernel/sys_oabi-compat.o] Error 1
make: *** [arch/arm/kernel] Error 2

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

                Don't walk behind me, I may not lead
             Don't walk in front of me, I may not follow
                Just walk beside me and be my friend
                          (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
