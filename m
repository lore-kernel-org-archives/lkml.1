Return-Path: <linux-kernel-owner+w=401wt.eu-S1765801AbXJRMDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765801AbXJRMDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763605AbXJRMDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:03:38 -0400
Received: from h155.mvista.com ([63.81.120.155]:42714 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761811AbXJRMDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:03:37 -0400
Message-ID: <47174BA5.7040700@ru.mvista.com>
Date: Thu, 18 Oct 2007 16:03:49 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux IDE <linux-ide@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 3/3] ide: Fix cs5535 driver accessing beyond array boundary
References: <20071018005624.DC749DDEAB@ozlabs.org>
In-Reply-To: <20071018005624.DC749DDEAB@ozlabs.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:

> The cs5535 use an incorrect construct to access the other drive
> of a pair, causing it to access beyond an array boundary on non-0
> interfaces. This fixes it by using the new ide_get_paired_drive()
> hepler instead.

> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

    Please update the driver version in the driver's heading comment. It also 
would be preferrable to fold this patch together with siimage path, or even 
fold all three together. Otherwise

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
