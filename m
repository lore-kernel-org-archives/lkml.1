Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYJUUDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYJUUDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYJUUC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:02:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbYJUUC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:02:59 -0400
Date: Tue, 21 Oct 2008 13:01:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: drepper@redhat.com, jakub@redhat.com, arjan@infradead.org,
       roland@redhat.com, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: Re: [PATCH v5] ELF: implement AT_RANDOM for glibc PRNG seeding
Message-Id: <20081021130111.b8d73625.akpm@linux-foundation.org>
In-Reply-To: <20081003175917.GX10632@outflux.net>
References: <20081001222706.68E7E1544B4@magilla.localdomain>
	<20081003001616.GN10632@outflux.net>
	<20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com>
	<20081003052938.GS10632@outflux.net>
	<20081002225718.6a0d803a@infradead.org>
	<48E5BAC6.9070007@redhat.com>
	<20081003145054.GU10632@outflux.net>
	<20081003145754.GH32682@tyan-ft48-01.lab.bos.redhat.com>
	<20081003173313.GW10632@outflux.net>
	<48E65964.5020809@redhat.com>
	<20081003175917.GX10632@outflux.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 10:59:17 -0700
Kees Cook <kees.cook@canonical.com> wrote:

> While discussing[1] the need for glibc to have access to random bytes
> during program load, it seems that an earlier attempt to implement
> AT_RANDOM got stalled.  This implements a random 16 byte string, available
> to every ELF program via a new auxv AT_RANDOM vector.
> 
> [1] http://sourceware.org/ml/libc-alpha/2008-10/msg00006.html

I read the above changeloglet and read the above-linked page and it's
still 87% unclear to me what this feature does.  Something to do with
stack randomisation, apparently.  I suppose I could go do further
hunting, but from the quality-of-changelog POV I don't think I should
need to do so.

IOW: better changelog, please.

It's unclear to me that the random-number issue got sorted out?
