Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbYHFGmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbYHFGmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 02:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYHFGmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 02:42:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:2552 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbYHFGmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 02:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s82vMUdB93I0tluaUh7/Q4wC+c3VAtxTnDzaDDm3OFGZL60Jj8+84TxOQz1SkSFzJf
         GJffajvDdxHKBdNcx6xvKDwOXe+Ms9sVmukBqdqzdwMqKd3yvV0rGA80U7yFqDQNWv0D
         MlxGlvcshhQqV2Uf1CXj3JnGSiHLLEOiCcw2k=
Message-ID: <b6a2187b0808052342w6fba9152m197d56aa9e88746a@mail.gmail.com>
Date: Wed, 6 Aug 2008 14:42:11 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080805.221917.42858161.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <20080805.221917.42858161.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 1:19 PM, David Miller <davem@davemloft.net> wrote:
> From: "Jeff Chua" <jeff.chua.linux@gmail.com>
> Date: Wed, 6 Aug 2008 11:15:30 +0800
> Do you have lockdep enabled?  If sure, try turning that off.

It's enabled by default, and I can't seem to disable it even if I
commented it out or delete it, it comes back after running "make".

CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y


Thanks,
Jeff.
