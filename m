Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYHLWfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYHLWfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYHLWfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:35:38 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:41683 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYHLWfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:35:37 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 18:35:37 EDT
Message-ID: <48A20E9E.9090100@tlinx.org>
Date: Tue, 12 Aug 2008 15:28:46 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: xfs-oss <xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>
CC: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS Lock debugging noise or real problem?
References: <48A093A7.40606@tlinx.org> <48A09CA9.9080705@sandeen.net> <48A0F686.2090700@tlinx.org> <48A0F9FC.1070805@sandeen.net>
In-Reply-To: <48A0F9FC.1070805@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
>   ...
Is it also known, (and the same bug) when you get the lock warnings when 
doing
"xfs_restore", as well (dio_get_page and xfs_ilock)...

Doesn't give me the warm & fuzzies, but I'm sure you've heard that 
sentiment plenty
of times...

The bugs with 'sort', & imap were both with xfs_ilock and 
shrink_icache_memory.

I saw another bug (different prog) with those two locks that was said to 
be a bug in
XFS by Andrew Morton, but he didn't say if it was the same known 
"harmless" "bug" or
if it was more serious.


