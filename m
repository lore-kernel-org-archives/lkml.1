Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619Ab0BYUaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:30:17 -0500
Received: from mail-iw0-f177.google.com ([209.85.223.177]:50054 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933525Ab0BYUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:30:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=HqK2lfJkhgb7UiAX8zn2xkgkotrhtvv3R+onD65Pfu3NUHYg5SYdXtS1z1ajjZPh5G
         T50pM06sZTQ3BhzmPDmOhq+sixxD8h7b8QX3pTRZQauiFrxNUfcO6l2ZjN/8ozbOjGVi
         kUL8p0pgzl2iYirny9Ed9ghBFTmXWwCGexrSk=
Message-ID: <4B86DDCB.50608@gmail.com>
Date: Thu, 25 Feb 2010 15:30:03 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 0/7] tcp: bugs and cleanup for 2.6.33
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd have thought that there would be greater interest about patching
crashing bugs, signed versus unsigned (underflow) bugs, TCP DoS bugs,
TCP data corruption, and TCP performance problems....

Combination of patches reported in October, November, December, January,
and February, for 2.6.32 and now 2.6.33.

This code has had previous review and several months of limited testing.

Some portions were removed during the various TCPCT part 1 patch splits,
then were cut off by the sudden unexpected end of that merge window.
[03 Dec 2009]  I've restarted the sub-numbering (again).

Of particular interest are the TCPCT header extensions that already
appear in the next phase of testing with other platforms.  These patches
allow correct reception without data corruption.

The remainder of the original TCPCT part 2 will be merged with part 3.

[Updated to 2010 Feb 24 2.6.33 release.]
