Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYCHOKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYCHOKz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 09:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYCHOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 09:10:45 -0500
Received: from [212.12.190.238] ([212.12.190.238]:35927 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753463AbYCHOKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 09:10:45 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Date: Sat, 8 Mar 2008 17:10:24 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200803081710.24137.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
>   On Fri, 7 Mar 2008, devzero@web.de wrote:
> >> * H. Peter Anvin <hpa@zytor.com> wrote:
> >>>       init=/path/to/any/sbin/chroot /newroot /sbin/init
>
> Great, I was looking for something like this myself some time ago!
>
> > wouldn`t it be useful to add a hint to kernel-parameters.txt ?
>
> How about:
>
>         init=           [KNL]
> -                       Format: <full_path>
> +                       Format: <full_path> <options>
>                         Run specified binary instead of /sbin/init as init
> -                       process.
> +                       process. init= is able to take more than one option
> +                       allowing us to do:
> +                       init=/path/to/any/sbin/chroot /newroot /sbin/init
> +                       ...and thus booting into /newroot.

Nice try, but this only works on the surface.  Try remounting root to see what I mean.

Now, for a patch that actually does what we want, try this:

[PATCH][retry-2] init: Introduce rootdir bootparm to select which dir to sys_chroot


Thanks!

--
Al

