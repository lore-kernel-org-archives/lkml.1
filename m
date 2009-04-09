Return-Path: <linux-kernel-owner+w=401wt.eu-S935017AbZDIPF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017AbZDIPF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765054AbZDIPFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:05:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:31123 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765675AbZDIPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:05:45 -0400
Message-ID: <49DE0EC4.4010409@petalogix.com>
Date: Thu, 09 Apr 2009 17:05:40 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: struct exception_table_entry
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

I am doing some cleanup things in MB MMU kernel and I looked at
exception_table_entry structure.
Only alpha use different types among others. Some arch use only
different names and types int/long.
I think that this structure could be moved to any generic location ->
asm-generic/uaccess.h folder.

I think that this structure types should be acceptable for every archs?

#ifndef exception_table_entry
struct exception_table_entry {
    unsigned long insn;
    unsigned long fixup;
};
#endif

What do you think?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

