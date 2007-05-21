Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbXEUFSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbXEUFSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXEUFSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:18:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:4919 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXEUFSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:18:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mzvFCoCCaxdabYzhuin6Od/7IP80wwKo6rKyxcL+ArAsESePsoqhtfjszKk1LMVp/tUd+8mF+16OKhIapKs5l0+dtczelgz6H0a4gXlZCS/Kqyq4sGirx9gpN/P06VGqKLDMxsdz30kU7qBi/gPORlg7uSk2Bm7+thKOoL3We9o=
Message-ID: <86802c440705202218x734fec17maee6ca8c475aecf6@mail.gmail.com>
Date: Sun, 20 May 2007 22:18:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Greg KH" <gregkh@suse.de>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>
Subject: [PATCH 0/3]x86: USB debug port early_printk support
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

early_printk support on x86 platform
the patch was started by Eric, and I used it in LinuxBIOS, and added
some timeout etc.
also make it consistent to latest tree about relocated kernel feature.

include three part
1. x86_64: early init pgt for fix virtual addr in head.S, so can use
set_fixmap before setup_arch.
2. i386: early init pgt for fix virtual addr in head.S, so can use
set_fixmap before setup_arch.
3. changes in early_printk for early debug port support.

It could be good material for 2.6.23.

We may need 1 for earlycon support for mmio type 8250 to use fix
virtual address.

YH
