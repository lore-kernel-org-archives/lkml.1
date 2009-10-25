Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZJYTdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZJYTdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZJYTdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:33:37 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:49402 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbZJYTdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:33:37 -0400
From: Frans Pop <elendil@planet.nl>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: udev in kernel source?
Date: Sun, 25 Oct 2009 20:33:40 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200910251834.06321.Martin@lichtvoll.de> <200910251930.36658.elendil@planet.nl> <200910251930.36658.elendil@planet.nl> <200910252004.21546.Martin@lichtvoll.de>
In-reply-To: <200910252004.21546.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910252033.41218.elendil@planet.nl>
X-OriginalArrivalTime: 25 Oct 2009 19:33:41.0588 (UTC) FILETIME=[0EE09140:01CA55AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(For the kernel mailing lists it is customary to reply-to-all. Due to the 
very high volume on linux-kernel it's otherwise easy to miss replies.)

Martin Steigerwald wrote:
> And there is another issue: AFAIK distributors handle at least parts of
> the udev configuration including rules.

Exactly. Those "plug-in" rules installed by other packages can quite easily 
conflict or overlap with a new version of udev.

For an example of how a udev update can break other programs, see
http://bugs.debian.org/545801.

> Maybe its more about the discoverability of such issue: I don't look into
> the boot log / syslog every day. ;)

Give logcheck a try. I run it on most of my systems, including my laptop.
 
> Hopefully upward incompatible changes in SysFS could be avoided in the
> future.

I wouldn't want to bet on that ;-)

Cheers,
FJP
