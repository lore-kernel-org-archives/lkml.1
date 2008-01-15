Return-Path: <linux-kernel-owner+w=401wt.eu-S1751907AbYAOOrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbYAOOrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYAOOrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:47:37 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:56488 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYAOOrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:47:36 -0500
Message-ID: <478CC76B.1020804@nortel.com>
Date: Tue, 15 Jan 2008 08:47:07 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network	packets
References: <20080115071950.GA1696@ff.dom.local>
In-Reply-To: <20080115071950.GA1696@ff.dom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2008 14:47:11.0186 (UTC) FILETIME=[8281A320:01C85785]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:

> IMHO, checking this with a current stable, which probably you are going
> to do some day, anyway, should be 100% acceptable: giving some input to
> netdev, while still working for yourself.

While I would love to do this, it's not that simple.

Some of our hardware is not supported on mainline, so we need per-kernel 
version patches to even bring up the blade.  The blades netboot via a 
jumbo-frame network, so kernel extensions are needed to handle setting 
the MTU before mounting the rootfs.  The blade in question uses CKRM 
which doesn't exist for newer kernels so the problem may simply be 
hidden by scheduling differences.  The userspace application uses other 
kernel features that are not in mainline (and likely some of them won't 
ever be in mainline--I know because I've tried).

Basically, the number of changes required for our environment makes it 
difficult to just boot up the latest kernel.

Chris
