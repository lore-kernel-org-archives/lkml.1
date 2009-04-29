Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZD2FBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZD2FBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbZD2E7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:59:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755061AbZD2E7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:59:14 -0400
Date: Tue, 28 Apr 2009 21:50:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Lynch <ntl@pobox.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro\@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "andi\@firstfloor.org" <andi@firstfloor.org>,
       "mpm\@selenic.com" <mpm@selenic.com>,
       "adobriyan\@gmail.com" <adobriyan@gmail.com>,
       "linux-mm\@kvack.org" <linux-mm@kvack.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Chandra Seetharaman <sekharan@us.ibm.com>,
       Olof Johansson <olof@lixom.net>, Helge Deller <deller@parisc-linux.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-Id: <20090428215050.67b7b4db.akpm@linux-foundation.org>
In-Reply-To: <m38wlkxe9b.fsf@pobox.com>
References: <20090428010907.912554629@intel.com>
	<20090428014920.769723618@intel.com>
	<20090428143244.4e424d36.akpm@linux-foundation.org>
	<20090429023842.GA10266@localhost>
	<m38wlkxe9b.fsf@pobox.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 23:41:52 -0500 Nathan Lynch <ntl@pobox.com> wrote:

> > CONFIG_DEBUG_KERNEL being enabled in distro kernels effectively means 
> >
> >         #ifdef CONFIG_DEBUG_KERNEL == #if 1
> >
> > as the following patch demos. Now it becomes obviously silly.
> 
> Sure, #if 1 is usually silly.  But if the point is that DEBUG_KERNEL is
> not supposed to directly affect code generation, then I see two options
> for powerpc:
> 
> - remove the #ifdef CONFIG_DEBUG_KERNEL guards from
>   arch/powerpc/kernel/sysfs.c, unconditionally enabling the hid/ima
>   sysfs attributes, or
> 
> - define a new config symbol which governs whether those attributes are
>   enabled, and make it depend on DEBUG_KERNEL

yup.
