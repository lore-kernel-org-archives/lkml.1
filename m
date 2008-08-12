Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYHLDf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYHLDf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYHLDfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:35:15 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:48868 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbYHLDfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:35:14 -0400
Message-ID: <48A104EB.6040509@tlinx.org>
Date: Mon, 11 Aug 2008 20:35:07 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: Re: Lock debugging noise or real problem?
References: <48A093A7.40606@tlinx.org> <48A09CA9.9080705@sandeen.net> <48A0F686.2090700@tlinx.org> <48A0F9FC.1070805@sandeen.net>
In-Reply-To: <48A0F9FC.1070805@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> I haven't looked closely at #2 but there have been so many lockdep
> reports for xfs, and so many explanations of why they don't always get
> along, you'll probably be able to find something with some searching.
>   
----

      So in debugging mysterious 'lockups' where I've, at least once, 
noticed a
hangcheck_timer elapse, this lock-checking stuff is just nonsensical?  
It is very
frustrating trying to turn on debug tools in the kernel and get so many 
false positives.

Would it be possible or, perhaps, desirable to eliminate the buggy 
lock-checks in the
xfs code?

Meanwhile...back to finding reasons for the semi-random, periodic hanging...
;^/


