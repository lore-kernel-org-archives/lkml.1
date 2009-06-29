Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZF2CI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZF2CI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 22:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZF2CIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 22:08:19 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:13730 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZF2CIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 22:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uEXreSryDBF13gOoH7zSYRlWsWxZ+ujvfM57ipNatAFpnbSOLK/PCeAJVtp4oHPocA
         XCOPGr5UcLQ1hSCdMk5+ET3BKKaQTmlk8Q1bd7C2cZ6rrLmzL5zZ8Hy/L+ZArDph71jl
         WtilLrShmAK7R8OV88QNoWg2fYBn8msFqH5Fw=
MIME-Version: 1.0
In-Reply-To: <a5d9929e0906270807s4c0ef74ap2296dce4c790ea9a@mail.gmail.com>
References: <a5d9929e0906270807s4c0ef74ap2296dce4c790ea9a@mail.gmail.com>
Date: Mon, 29 Jun 2009 10:08:19 +0800
Message-ID: <2375c9f90906281908k7aa089a3v932dd368d572194b@mail.gmail.com>
Subject: Re: Crashes during boot on 2.6.30 / 2.6.31-rc, random programs
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 11:07 PM, Joao
Correia<joaomiguelcorreia@gmail.com> wrote:
> Hello
>

Hello,

> Since midway through the 2.6.30 series, and continuing on the rc1 for
> .31, im having this at every boot, during the boot process:
>
> (...)
> Jun 26 21:07:03 hightech kernel: NET: Registered protocol family 10
> Jun 26 21:07:03 hightech kernel: lo: Disabled Privacy Extensions
> Jun 26 21:07:03 hightech kernel: BUG: MAX_STACK_TRACE_ENTRIES too low!
> Jun 26 21:07:03 hightech kernel: turning off the locking correctness validator.
> Jun 26 21:07:03 hightech kernel: Pid: 672, comm: modprobe Not tainted
> 2.6.31-rc1 #1

Could you please try the patch from Ingo below?

http://article.gmane.org/gmane.linux.kernel/852005

Does it help?

That value was already doubled from 131072 when the last time it was seen. :)

Thanks.
