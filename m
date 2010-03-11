Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab0CKLfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:35:52 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57324 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab0CKLfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:35:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=OYgrBEf/cGEBiBWb+ss0K5E5ZWPwEKru3sy2NMFZd+KPxsrGlEO6+FcRrJP8pLGGip
         fbMpN/a6J8hrIUTWKM5XEyfnI5IWAt3nQIlwUNSQguaG2RIVy8Xjqh+QnAh7cRMQ1RZc
         TwPvyz5ABILayLA8Kdz1qLwS49j+a6aVBNDoQ=
Message-ID: <4B98D592.6040301@gmail.com>
Date: Thu, 11 Mar 2010 06:35:46 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 0/7] tcp: bugs and cleanup for 2.6.34-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd have thought that there would be greater interest about patching
crashing bugs, signed versus unsigned (underflow) bugs, TCP DoS bugs,
TCP data corruption, and TCP performance problems....

There's been ample warning.  Zero-day security issues will be reported
to the usual announcement lists.  In particular, these 0day exploits
affect systems as far back as the 2005 changeover to git.

Combination of patches reported in October, November, December, January,
and February, for 2.6.32, 2.6.33, and now 2.6.34.

This code has had previous review and several months of limited testing.

Some portions were removed during the various TCPCT part 1 patch splits,
then were cut off by the sudden unexpected end of that merge window.
[03 Dec 2009]  I've restarted the sub-numbering (again).

Of particular interest are the TCPCT header extensions that already
appear in the next phase of testing with other platforms.  These patches
allow correct reception without data corruption.

The remainder of the original TCPCT part 2 will be merged with part 3.

[Updated to 2010 Mar 08 2.6.34-rc1.]
