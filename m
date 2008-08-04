Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbYHDNYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbYHDNYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbYHDNX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:23:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198AbYHDNX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:23:56 -0400
Message-ID: <489702B9.5030204@linux-foundation.org>
Date: Mon, 04 Aug 2008 08:23:05 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: detach SLUB_DEBUG and SYSFS
References: <20080801000405.GA7072@martell.zuzino.mipt.ru> <48941C2F.8010406@cs.helsinki.fi>
In-Reply-To: <48941C2F.8010406@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Alexey Dobriyan wrote:
>> Right now, SYSFS=n means no SLUB debugging, no even basic poisoning,
>> to hell with tunables.
> 
> Applied, thanks!

Do not apply. This partially reverts an earlier commit and would cause build
issues because the #ifdef parts in slub.c were not reverted.

