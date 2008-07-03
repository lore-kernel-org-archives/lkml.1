Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYGCXnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYGCXnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbYGCXnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:43:06 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:54621 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756650AbYGCXnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:43:04 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.26-rc8-mm1--No e100 :( logs say missing firmware
Date: Fri, 04 Jul 2008 09:42:54 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <6toq6493rbba4n4s8l2csvobo13673tgu5@4ax.com>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
In-Reply-To: <20080703020236.adaa51fa.akpm@linux-foundation.org>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008 02:02:36 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:

>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1/

Hi, it booted up on a Core2Duo box but failed to connect via e100 NIC 
to localnet.

/var/log/messages:

Jul  4 09:14:13 pooh kernel: firmware: requesting e100/d102e_ucode.bin
Jul  4 09:14:13 pooh firmware.sh[1666]: Cannot find  firmware file 'e100/d102e_ucode.bin'

/var/log/syslog:

Jul  4 09:14:13 pooh kernel: e100: eth0: e100_request_firmware: Failed to load firmware "e100/d1
02e_ucode.bin": -2
Jul  4 09:14:13 pooh kernel: e100: eth0: e100_request_firmware: Failed to load firmware "e100/d1
02e_ucode.bin": -2
Jul  4 09:17:17 pooh kernel: e100: eth0: e100_request_firmware: Failed to load firmware "e100/d1
02e_ucode.bin": -2
Jul  4 09:17:30 pooh last message repeated 3 times

So where did the firmware go? -- I been using these e100 NICs for years, 
2.4 & 2.6 kernels, never seen this kind of failure...


Duped mesg with typo corrected so searching Subject line works.

Thanks,
Grant.
