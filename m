Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYAHTbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYAHTbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYAHTbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:31:31 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:7796 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYAHTba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:31:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=kblrZ8VYzOBxILV2V5gUY4QXLx85EXjkxzQKgoyf/SzQ8rcPsr5G4I7IuWEDsx6OL8VrQV5wOb0wsNvQqIbV6Zhlb6gSip2dEZWyxTneqljbSsPqgL8C0zYpqrzLz56Oxovpr126FoNmnoZccEm/DxfHanaV/gyb75pVplTLOeM=
Date: Tue, 8 Jan 2008 20:31:38 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mingo@elte.hu
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: [PATCH 0/5] x86: coding style fixes in arch/x86/ia32/
Message-ID: <20080108203138.4d43937c@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the following 5 patches fix 227 errors and 2 warnings
reported by checkpatch.pl

I hope they don't introduce problems in the process and 
that they can be applied.

I know there is no agreement on the list about whether these
patches should be posted/accepted or not so I'm just resending
the mangled patches that already hit the list.

I'll then start working what Andi suggested here:
http://lkml.org/lkml/2008/1/8/213

Ingo, I would appreciated your feedback about the work I'm 
doing, if you want me to stop or continue.
If you want me to work on further fixes I would appreciate
if you could indicate files that needs fixing minimazing
impacts on the overall process.

Thanks.


--- BEFORE ---
ia32_signal.c
total: 96 errors, 11 warnings, 617 lines checked

ia32_binfmt.c
total: 41 errors, 5 warnings, 285 lines checked

ia32_aout.c
total: 50 errors, 18 warnings, 528 lines checked

fpu32.c
total: 39 errors, 1 warnings, 183 lines checked

audit.c
total: 1 errors, 0 warnings, 42 lines checked

Total
total: 227 errors, 35 warnings


--- AFTER ---
ia32_signal.c
total: 3 errors, 9 warnings, 617 lines checked

ia32_binfmt.c
total: 2 errors, 5 warnings, 285 lines checked

ia32_aout.c
total: 2 errors, 18 warnings, 526 lines checked

fpu32.c
total: 2 errors, 1 warnings, 183 lines checked

audit.c
total: 0 errors, 0 warnings, 42 lines checked

Total
total: 9 errors, 33 warning


-- 
Paolo
paolo.ciarrocchi.googlepages.com
