Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbZC3HQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbZC3HQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZC3HP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:15:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:20755 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZC3HP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:15:56 -0400
Message-ID: <49D071A8.4010703@petalogix.com>
Date: Mon, 30 Mar 2009 09:15:52 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Removing __kernel_old_uid_t, git_t, dev_t
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

on the base our discussion some month ago you recommend me to remove old
kernel types.
I did some tests and I found that first step must be to remove all
references in linux kernel code because of compilation error.
Just perform grep to include linux folder.

I think we should create this patch first and then I can remove them
from MB posix_types.h.

Do you agree with me?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

