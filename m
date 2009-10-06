Return-Path: <linux-kernel-owner+w=401wt.eu-S933188AbZJFU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbZJFU3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933147AbZJFU3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:29:39 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:49662 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbZJFU3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:29:38 -0400
MIME-Version: 1.0
In-Reply-To: <20091006110211.139b91e5.randy.dunlap@oracle.com>
References: <20091006165220.b5cb1c44.sfr@canb.auug.org.au>
	 <20091006110211.139b91e5.randy.dunlap@oracle.com>
Date: Tue, 6 Oct 2009 16:29:01 -0400
Message-ID: <7e0fb38c0910061329x54b90f8djb2db59ce6152c19e@mail.gmail.com>
Subject: Re: [PATCH -next] cpufreq: provide cpufreq_get stub
From: Eric Paris <eparis@parisplace.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
       Avi Kivity <avi@redhat.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 2:02 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> When CONFIG_CPU_FREQ is disabled, cpufreq_get() needs a stub.
> Used by kvm (although it looks like a bit of the kvm code could
> be omitted when CONFIG_CPU_FREQ is disabled).
>
> arch/x86/built-in.o: In function `kvm_arch_init':
> (.text+0x10de7): undefined reference to `cpufreq_get'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

It does what it says it does and gives me a building kernel again.

Tested-by: Eric Paris <eparis@redhat.com>
