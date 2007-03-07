Return-Path: <linux-kernel-owner+w=401wt.eu-S2992481AbXCGTCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992481AbXCGTCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992475AbXCGTB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:01:59 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:8877 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992481AbXCGTB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:01:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KsbReoRARRzEAyBbVfpc9FASciyEhgzf8e2/XPWcmsXVZxOOyeqr4WkNZT3KaxftqE+CNtwTH3hzINRYd9O85/TiDPeRPJyc3oMaIoM+jZiGGbu2syFSWal8EmuKeoDkyjEexVIeUMdNhNIH9DaG1VdP87dZJezOPnGwEdxsuxg=
Message-ID: <a44ae5cd0703071101q16188b9pc5e8dbc226a7283d@mail.gmail.com>
Date: Wed, 7 Mar 2007 11:01:55 -0800
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       "Joerg Roedel" <joerg.roedel@amd.com>, "Andi Kleen" <ak@suse.de>
Subject: 2.6.21-rc2-mm2 -- hot-fix "revert-optimize-and-simplify-get_cycles_sync.patch" broke my build
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from include/asm/timex.h:10,
                 from include/linux/timex.h:187,
                 from include/linux/sched.h:50,
                 from include/linux/utsname.h:35,
                 from include/asm/elf.h:12,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:15,
                 from include/linux/crypto.h:21,
                 from arch/i386/kernel/asm-offsets.c:7:
include/asm/tsc.h: In function 'get_cycles_sync':
include/asm/tsc.h:45: warning: implicit declaration of function 'alternative_io'
include/asm/tsc.h:46: error: called object '"=a"' is not a function
include/asm/tsc.h:46: error: called object '"0"' is not a function
include/asm/tsc.h:46: error: expected ')' before ':' token
make[1]: *** [arch/i386/kernel/asm-offsets.s] Error 1
