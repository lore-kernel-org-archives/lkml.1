Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYLaJX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYLaJX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYLaJXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:23:48 -0500
Received: from ozlabs.org ([203.10.76.45]:55327 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbYLaJXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:23:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH -tip] cpumask: fix bogus kernel-doc
Date: Wed, 31 Dec 2008 19:53:37 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <495B313E.7060701@cn.fujitsu.com>
In-Reply-To: <495B313E.7060701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812311953.39184.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008 19:15:50 Li Zefan wrote:
>   * @mask: pointer to cpumask_var_t where the cpumask is returned
>   *
>   * Only defined when CONFIG_CPUMASK_OFFSTACK=y, otherwise is
> - * a nop returning a constant 1 (in <linux/cpumask.h>)
> + * a nop (in <linux/cpumask.h>).
>   * Either returns an allocated (zero-filled) cpumask, or causes the
>   * system to panic.
>   */

Thanks, applied!
Rusty.
