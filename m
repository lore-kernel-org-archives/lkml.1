Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab0BNGBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 01:01:55 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:62037 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0BNGBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 01:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ZBZX8gQoRKsJoE6WJ8IjjuCkt1ImHecoZfpHxfkDrhvrAJiip53IMiFeL2wrGIstSW
         bo8uxBC9gwQ+dY9c9meXdAQtbks3aNvLBOFfs0xoNRSW/IYQz7ScLWIyx9hVCOY1gaJm
         myCefVai8oGXxc4HJuxEDsADSnoGIWPaa20SE=
Message-ID: <4B7791CF.9030201@gmail.com>
Date: Sun, 14 Feb 2010 01:01:51 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 0/7] tcp: bugs and cleanup updated to 2.6.33-rc8
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

[Parts 2f and 2g updated, improving resistance to very rare option
re-ordering by middleware.]
