Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZA0Aq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZA0Aq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbZA0AqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:46:17 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:8108 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZA0AqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:46:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=d/xNOAvB2gpl2Sg46qjq3RidufE2+p4aFTPkHgTPiulsMYroqiaHYZrJXlk5qqFCHe
         9I8DaIJu5Gea5NAj06OPkSvdIwne7vn3ZC7TNn64d+UOP2kM5w43Fc4F64MT6X6BYRqO
         FTQskkSRqWOTk+qqKyJgMRQdxmcLmWOQZrj/w=
Message-ID: <497E595F.2010708@gmail.com>
Date: Tue, 27 Jan 2009 01:46:23 +0100
From: Michael Kerrisk <mtk.manpages@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: narendramind@spikesource.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, torvalds@osdl.org,
       linux-abi@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: syscalls: sys_setrlimit64/sys_getrlimit64 calls
 to provide FSIZE  limits > 2^32-1
References: <200901231759.n0NHxKA3009104@eng-pool-55.spikesource.com> <200901262004.16364.arnd@arndb.de>
In-Reply-To: <200901262004.16364.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 23 January 2009, narendramind@spikesource.com wrote:
>>   The solution to this problem would require new setrlimit64() and 
>>   getrlimit64() system calls on x86, and the existing 32-bit system calls 
>>   would need to be retained so that existing binaries would still run.
> 
> When adding new syscalls, please Cc: linux-abi@vger.kernel.org and

Arnd -- I think you meant linux-api, not linux-abi.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
