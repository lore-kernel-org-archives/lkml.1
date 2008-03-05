Return-Path: <linux-kernel-owner+w=401wt.eu-S932826AbYCEMM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbYCEMM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762691AbYCEMMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:12:17 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:58316 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569AbYCEMMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:12:16 -0500
Message-ID: <47CE8E21.2000309@davidnewall.com>
Date: Wed, 05 Mar 2008 22:42:17 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: David Miller <davem@davemloft.net>, dmantipov@yandex.ru,
       linux-kernel@vger.kernel.org
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
References: <1389671204703217@webmail34.yandex.ru> <20080305.000014.245410231.davem@davemloft.net> <47CE6C41.3090303@cosmosbay.com>
In-Reply-To: <47CE6C41.3090303@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> I tried the 'pipe' prog on a fresh linux-2.6.24.2, on a dual Xeon 5120
> machine, and we can notice that four cpus are used (but only two
> threads are running on this benchmark)

Do the threads migrate from CPU to CPU?  That would be sub-optimal,
wouldn't it?
