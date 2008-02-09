Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYBIWpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYBIWpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 17:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbYBIWpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 17:45:21 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:54928 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754930AbYBIWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 17:45:20 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Feb 2008 17:45:19 EST
Message-ID: <47AE2BCC.3040605@lwfinger.net>
Date: Sat, 09 Feb 2008 15:40:12 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Query about set_pages_* API
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is the set_pages_* API that replaces change_page_attr described somewhere? I have been unable to 
find it with Google.

I'm trying to modify the VirtualBox kernel module to work with 2.6.24-git (and 2.6.25) on x86_64 
architecture. The current code has a value of the third argument of the call (prot) with 3 variants. 
All variations have the following bits set: _PAGE_PRESENT, _PAGE_RW, _PAGE_DIRTY, and 
_PAGE_ACCESSED. Number 2 adds _PAGE_NX to the above, and number 3 adds _PAGE_GLOBAL to the bits in 
variation 1.

 From the code in arch/x86/mm/pageattr.c, I figured I need to call set_pages_wb() unconditionally, 
and set_pages_nx() if _PAGE_NX is set. Will these calls be sufficient? I thought about calling 
set_pages_rw(), but that entry is not exported.

Thanks,

Larry
