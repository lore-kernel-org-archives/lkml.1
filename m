Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0BOMXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 07:23:13 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:40648 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab0BOMXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 07:23:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=LW/22DyZghElyhsr1MAdmG0LhwJGnRIBaWiu0FNxI7q48wVKPvWlv33+wOA20uRB8B
         JYAxbNH44Bupuf61oQ65Gd/wb7Xbirow6byLsLRLQpSiq+MsWaLQR3+HC8Hp3lz7pk+N
         BCorhpWRUf4pR2nuABLwBWO6Q134382hww7co=
Message-ID: <4B793CAA.2030902@gmail.com>
Date: Mon, 15 Feb 2010 07:23:06 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>
CC: Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 0/7] tcp: bugs and cleanup updated to 2.6.33-rc8 (again)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combination of patches reported in October, November, December, January
and February.  These patches fix perceived bugs, and other cleanup.

This code has had previous review and several months of limited testing.

Some portions were removed during the various TCPCT part 1 patch splits,
then were cut off by the sudden unexpected end of that merge window.
[03 Dec 2009]  I've restarted the sub-numbering (again).

Of particular interest are the TCPCT header extensions that already
appear in the next phase of testing with other platforms.  These patches
allow correct reception without data corruption.

The remainder of the original TCPCT part 2 will be merged with part 3.

These are patches against the current linux-2.6 tree.

[Parts 2f and 2g updated, fixing some more problems introduced by
David Miller in commit bb5b7c11263dbbe78253cd05945a6bf8f55add8e]

