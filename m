Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277Ab0AWF1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0AWF1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 00:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853Ab0AWF1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 00:27:35 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:61746 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0AWF1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 00:27:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=oZziHZfSWr2l+b3F6RTTJGFHFekmEsDUs54V42D8aMWGiVhwiVCPiRkIJTZBAsTD1k
         t1WYdGKQTd3uULzy20KlW9N9YmUeaoiS2ckOFaWvEkjPtY9pCfD3aMldEZPwD/Bc3R45
         IJGsXYnml/rlb6KYfHWItdS7ueLtqEvY+vGpU=
Message-ID: <4B5A88C4.7050205@gmail.com>
Date: Sat, 23 Jan 2010 00:27:32 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/7] tcp: bugs and cleanup updated to 2.6.33-rc5
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
