Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYGZJrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYGZJrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYGZJrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:47:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53939 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYGZJrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:47:14 -0400
Date: Sat, 26 Jul 2008 18:47:07 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Subject: Re: What to do with `kswapd0: page allocation failure. ` ?
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <488AAB54.8070801@xs4all.nl>
References: <20080726060755.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com> <488AAB54.8070801@xs4all.nl>
Message-Id: <20080726184636.3175.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > no bug.
> > this stack trace speak to
> > 
> > 1. memory pressure increased
> > 2. kswapd ran
> > 3. network packet received
> > 4. interrupt for network happend
> > 5. but can't allocate memory for network buffer(skb).
> > 6. Then, packet dropped
> > 7. Then, warning happend.
> > 
> > your network peer may resend the same packet after few times.
> > no problem.
> 
> Thanks.
> This was on a 4GB AMD X86_64 machine running Fedora 9.
> The memory was not loaded that much. (~2 GB)
> Or was the (largish) file being cached, filling up RAM?

maybe..


