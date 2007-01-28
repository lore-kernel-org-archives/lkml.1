Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXA1KIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXA1KIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 05:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932521AbXA1KIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 05:08:23 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:40978 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbXA1KIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 05:08:23 -0500
Message-ID: <45BC7612.30701@gmail.com>
Date: Sun, 28 Jan 2007 11:08:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Unable to select IPV6 [Was: 2.6.20-rc6-mm1]
References: <20070127234928.64d8e437.akpm@osdl.org>
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> Temporarily at
> 
> 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/

Unable to select IPV6. Menuconfig doesn't offer it when INET is selected. When 
it's not it appears in the menu, but after state change it gets away. The same 
behaviour in xconfig, gconfig.

$ mkdir ../a/tst
$ make O=../a/tst menuconfig
   HOSTCC  scripts/basic/fixdep
[...]
   HOSTLD  scripts/kconfig/mconf
scripts/kconfig/mconf arch/i386/Kconfig
Warning! Found recursive dependency: INET GFS2_FS_LOCKING_DLM SYSFS OCFS2_FS INET

Maybe this is the problem?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
