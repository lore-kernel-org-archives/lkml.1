Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbYIVNQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbYIVNQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYIVNPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:15:52 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:10734 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752047AbYIVNPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:15:51 -0400
Message-ID: <48D79ABD.8060805@ru.mvista.com>
Date: Mon, 22 Sep 2008 17:16:45 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Mark de Wever <koraq@xs4all.nl>
Cc: Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
References: <20080921185138.GA16310@localhost>
In-Reply-To: <20080921185138.GA16310@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mark de Wever wrote:

> After updating my kernel to 2.6.26 the output for the ide-tape drive
> during booting is garbled eg
> ide-tape: hdd <-> ht0: Seagate <98>ß8A51|1À<81>Üº<98>ß STT20000A rev 8A51|1À<81>Üº<98>ß

> This patch fixes the problem by NULL terminating the strings.

    Looks like this bugs was introduced by this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=41f81d545b6b1f585a02d1d8545978714f710e91

MBR, Sergei
