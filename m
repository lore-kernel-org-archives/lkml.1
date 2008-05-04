Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYEDXOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYEDXOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 19:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYEDXOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 19:14:04 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53036 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751114AbYEDXOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 19:14:03 -0400
Date: Sun, 4 May 2008 18:13:59 -0500
From: Paul Jackson <pj@sgi.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] x86: x86-64defconfig remake
Message-Id: <20080504181359.a39d766b.pj@sgi.com>
In-Reply-To: <20080504155719.GA6842@cvg>
References: <20080504155719.GA6842@cvg>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill wrote:
> The current x86_64_defconfig contains a number of nonexistent
> symbols.

These symbols don't exist in what context?

The one I notice:

-# CONFIG_CPUSETS is not set

certainly exists, in init/Kconfig:

    config CPUSETS
	bool "Cpuset support"
	depends on SMP && CGROUPS

and is enabled by default in some configs:

    arch/ia64/configs/sn2_defconfig
    arch/mips/configs/ip27_defconfig
    arch/mips/configs/sb1250-swarm_defconfig
    arch/powerpc/configs/cell_defconfig
    arch/powerpc/configs/ppc64_defconfig
    arch/powerpc/configspseries_defconfig

I could be tempted to enable cpusets by default in x86_64
as well, however I don't understand the tradeoffs of such
a change well enough to know if I should propose that.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
