Return-Path: <linux-kernel-owner+w=401wt.eu-S1763655AbYA1XHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763655AbYA1XHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763473AbYA1XHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:07:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763459AbYA1XH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:07:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=GVF4AFv30I3ST8sAEvCsrLx7EpiGVKRhZ7Q8S3dWv35T/I9tGIMsA+ATBIXmzuNnR7o9kI88j5gHdaqEseSAkUnHKPgpxaQ4Lhpnz+Nos+itrU1G8G7W+DCM68ubm7/TNKGKcuhtoCoMOmjxZtG5jlEXNJdGSA5Rlo+aF23r8JI=
Date: Tue, 29 Jan 2008 00:07:21 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] X86: Clean up arch/x86/math-emu/errors.c
Message-ID: <20080129000721.68d6bfdd@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series implements a few clean up suggested by
checkpatch.pl

I compiled tested every single patch and verified that
the clean up only patches are not modifying the md5sum of 
the relative .o file.

Before the patches:
total: 214 errors, 28 warnings, 739 lines checked

After:
total: 2 errors, 1 warnings, 674 lines checked

arch/x86/math-emu/errors.c |  431 +++++++++++++++++++-------------------------
 1 files changed, 183 insertions(+), 248 deletions(-)
