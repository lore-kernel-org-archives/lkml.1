Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYGYVOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYGYVOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYGYVOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:14:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44376 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYGYVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:14:01 -0400
Date: Sat, 26 Jul 2008 06:13:52 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Subject: Re: What to do with `kswapd0: page allocation failure. ` ?
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4889D471.2050301@xs4all.nl>
References: <4889D471.2050301@xs4all.nl>
Message-Id: <20080726060755.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hello,
> 
> Found a few of these logged. See below.
> What are they? Harmfull? Bug?

no bug.
this stack trace speak to

1. memory pressure increased
2. kswapd ran
3. network packet received
4. interrupt for network happend
5. but can't allocate memory for network buffer(skb).
6. Then, packet dropped
7. Then, warning happend.

your network peer may resend the same packet after few times.
no problem.




