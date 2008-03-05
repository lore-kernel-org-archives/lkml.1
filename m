Return-Path: <linux-kernel-owner+w=401wt.eu-S1765289AbYCEKTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765289AbYCEKTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761683AbYCEKTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:19:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761071AbYCEKTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:19:41 -0500
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Miller <davem@davemloft.net>, dmantipov@yandex.ru,
       linux-kernel@vger.kernel.org
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
From: Andi Kleen <andi@firstfloor.org>
References: <1389671204703217@webmail34.yandex.ru>
	<20080305.000014.245410231.davem@davemloft.net>
	<47CE6C41.3090303@cosmosbay.com>
Date: Wed, 05 Mar 2008 11:19:36 +0100
In-Reply-To: <47CE6C41.3090303@cosmosbay.com> (Eric Dumazet's message of "Wed\, 05 Mar 2008 10\:47\:45 +0100")
Message-ID: <p73d4q95v7r.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> writes:
>
> This benchmarek mostly stress scheduler AFAIK, not really pipe() code...
>
> Lot of context switches...

The recent mysql sysbench benchmark where they also won was also such
a (somewhat unrealistic) scheduler benchmark with a lot of over
scheduling. Just speculating here, but perhaps the context switch got
slower recently?

-Andi
