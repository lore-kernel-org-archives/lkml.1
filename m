Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0BBQIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 11:08:15 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:64586 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0BBQIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:08:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ZUBPXNo/vU1g2DF5bK6uqqbDl5RL9KWe0f/bKYR+DkpZb7E5R0TD+fQruy4sgxlJ36
         9I3CaiANFTMQuQdyUWY8SnrKdUqPSEsy8tFfQljl9muvVxbEpnQsRApunJIGc4xXpGH/
         /jVkgRtAvIcBsBdanUO93hRWeHTWGPWiPBAlM=
Message-ID: <4B684DE7.3020601@gmail.com>
Date: Tue, 02 Feb 2010 11:08:07 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/7] tcp: bugs and cleanup updated to 2.6.33-rc6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combination of patches reported in October, November, December, and
January.  These patches fix perceived bugs, and other cleanup.

This code has had previous review and several months of limited testing.

Some portions were removed during the various TCPCT part 1 patch splits,
then were cut off by the sudden unexpected end of that merge window.
[03 Dec 2009]  I've restarted the sub-numbering (again).

Of particular interest are the TCPCT header extensions that already
appear in the next phase of testing with other platforms.  These patches
allow correct reception without data corruption.

The remainder of the original TCPCT part 2 will be merged with part 3.

These patches are against the current linux-2.6 tree.

[No substantive changes from previous submission of January 23rd.]

