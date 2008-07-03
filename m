Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYGCQLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYGCQLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYGCQKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:10:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20633 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYGCQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:10:52 -0400
Cc: mchan@broadcom.com, LKML Kernel <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, linux-next@vger.kernel.org
Message-Id: <B8CBA141-D78E-4EEF-92C4-9CF7184E6C7F@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20080703205548.D6E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Date: Thu, 3 Jul 2008 12:10:02 -0400
References: <20080703020236.adaa51fa.akpm@linux-foundation.org> <20080703205548.D6E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Apple Mail (2.926)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 3, 2008, at 7:59 AM, KOSAKI Motohiro wrote:
> Hi Michael,
>
> my server output following error message on 2.6.26-rc8-mm1.
> Is this a bug?
>
> ------------------------------------------------------------------
> tg3.c:v3.93 (May 22, 2008)
> GSI 72 (level, low) -> CPU 0 (0x0001) vector 51
> tg3 0000:06:01.0: PCI INT A -> GSI 72 (level, low) -> IRQ 51
> firmware: requesting tigon/tg3_tso.bin
> tg3: Failed to load firmware "tigon/tg3_tso.bin"
> tg3 0000:06:01.0: PCI INT A disabled
> GSI 72 (level, low) -> CPU 0 (0x0001) vector 51 unregistered
> tg3: probe of 0000:06:01.0 failed with error -2
> GSI 73 (level, low) -> CPU 0 (0x0001) vector 51
> tg3 0000:06:01.1: PCI INT B -> GSI 73 (level, low) -> IRQ 52
> firmware: requesting tigon/tg3_tso.bin

Same problem here with linux-next on a Dell Latitude D620.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
