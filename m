Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZLXD7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZLXD7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 22:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZLXD7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 22:59:04 -0500
Received: from mail.windriver.com ([147.11.1.11]:55531 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZLXD7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 22:59:01 -0500
Message-ID: <4B32E6FC.40103@windriver.com>
Date: Wed, 23 Dec 2009 21:58:52 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: kgdb tree build failure
References: <20091224115624.77c910d6.sfr@canb.auug.org.au>
In-Reply-To: <20091224115624.77c910d6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Dec 2009 03:58:52.0961 (UTC) FILETIME=[683C4910:01CA844D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Jason,
>
> Today's linux-next build (i386 defconfig) failed like this:
>
> drivers/built-in.o: In function `drm_fb_kdb_enter':
> drm_fb_helper.c:(.text+0x6567a): undefined reference to `kgdb_active'
> drivers/built-in.o: In function `drm_fb_helper_free':
> (.text+0x65ec7): undefined reference to `dbg_kms_console_ops_unregister'
> drivers/built-in.o: In function `drm_fb_helper_single_fb_probe':
> (.text+0x6645d): undefined reference to `dbg_kms_console_ops_register'
>
> Clearly, the kgdb patches need some more testing.  Please remove them
> from linux-next until that is done.
>
>   

All the kdb patches were dropped from kgdb-next / linux-next.  All the
embedded type configs build and boot just fine.   The root of the
problem was that there was a gap in testing all the various combinations
where you can builds some things as a module or somethings as a built in.

The error you reported is already fixed, but the code base will not be
resubmitted until a new round of build and boot tests are completed.

Thanks,
Jason.
