Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYDHDDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYDHDDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 23:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYDHDDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 23:03:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38586 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYDHDDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 23:03:08 -0400
Date: Tue, 8 Apr 2008 05:03:07 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: andy@greyhouse.net
cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc8-git5: Reported regressions from 2.6.24
In-Reply-To: <200804071459.35628.rjw@sisk.pl>
Message-ID: <alpine.LNX.1.10.0804080459100.17722@fbirervta.pbzchgretzou.qr>
References: <200804071459.35628.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-04-07 14:59, Rafael J. Wysocki wrote:
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10323
>Subject		: panic using bridging on linus kernel 2.6.25-rc6
>Submitter	: Andy Gospodarek <andy@greyhouse.net>
>Date		: 2008-03-25 11:40 (14 days old)

>From BZ:

	“It looks like 2.6.24 is good, I guess I'll start bisecting....”

there have been two bridge-related patches between v2.6.24-rc6..v2.6.24:

  2dc2f20... [NETFILTER]: bridge-netfilter: fix net_device refcnt leaks
  2948d2e... [NETFILTER]: bridge: fix double POST_ROUTING invocation

Maybe it helps to try 2dc.
Not anymore a 2.6.25-rc issue it seems?
