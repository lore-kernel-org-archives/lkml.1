Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZDTHoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZDTHoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZDTHoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:44:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:38073 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZDTHoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=djtzVVqXeGWrAEwYQPaRaCSVhcUqFjOfg7+hsXYNOOnnybObSoOF1foUb+eAtDeJ6g
         kkHrRCje6EMMDXXEIzt16kYnhfOoNlxVcYY085KzYVBNuAN+PLqE0o43MFMI20DfsPq3
         jkVss2nfmRnAJsJlPYmk81RYwYeI8ApVokQD8=
MIME-Version: 1.0
Date: Mon, 20 Apr 2009 01:44:08 -0600
Message-ID: <e743c9de0904200044j1f71310ar122c8ea1fdcd2649@mail.gmail.com>
Subject: Kernel Panic: Early exception with 2.6.29.1-rt8 on x86_64
From: tom smith <tsmithtree@gmail.com>
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm using kernel 2.6.29.1 without the rt patch and it works fine,
but with the rt8 patch I recieve a kernel panic immediately after the
bootloader. Both were using the same configuration with the exception
of the realtime preemption options. I previously used 2.6.26.8-rt16
iirc and it worked fine, with the same configuration as well. early
printk is enabled. I have uploaded my .config, lspci, dmesg from a
working kernel, and the crash output from the kernel.
http://www.persuasiveigloo.com/linux/ Thanks for reading, if you think
any other outputs/configs would be helpful to debug this issue I will
gladly upload them. please cc me as I am off list for linux-kernel
