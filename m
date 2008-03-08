Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbYCHBx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbYCHBx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYCHBxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:53:12 -0500
Received: from po-out-1718.google.com ([72.14.252.156]:4716 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333AbYCHBxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:53:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dM8LIFGMsPNB5D5CgW5CXrahzQG/tKEMJnK/Cga+K88ifk8JsLPRaCNRVJfqBmB0rFduukeVKtSpGTngXlvnH9SR4CCbsZwFPdrsMz2z0cUI3pmMkmomFMcxmSSVsA/BO2bBMFuwOo7ixN3koVBGx8/BdmDWaKMs4dGkxcrox3M=
Message-ID: <4a3acf9f0803071753x19043628t2ffda8ce6e946e18@mail.gmail.com>
Date: Sat, 8 Mar 2008 09:53:07 +0800
From: "=?GB2312?B?xNq6y9e319k=?=" <kerneltrack@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Question about pdflush's two ratio?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, buddy, In these days, I'm watching about how the pdflush kernel
thread implemented. But we I saw there are two "*_ratio", I was
puzzled about these.

My kernel version is 2.6.9 and I found get_dirty_limits() in
page-writeback.c in KERNEL_SOURCE/mm.

After read the source and annotation about the function , I got that idea about
1. *dirty_ratio* is just for work with the number in system page
cache. It means if the (dirty pages number in system)/(total number
pages) is above the
    ratio , then we start pdflush.
2. *background_ratio* is just for every process. It means if there
were a single_process write pages and (its dirty pages) / (total
number pages in system)
    is above th ratio, then we also start pdflush.

This is my interpetation. But does it correct?

 Thx.
Jiancong
