Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYJXBki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYJXBki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYJXBk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:40:29 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:40535 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbYJXBk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=SDCdc1swxu1qBWb3nSg0T/hs/rOiKIFDSwv7my4Ug/ZeN4GzTziR5+yfAMYphwc2x6
         HhRBP44OGmMLNFB3UqR1xHeltBvSvi3H4ceoVaABPGAZNDi16mVr/vdNx8Eq3o/D9S0R
         rqBHgnNrA0BU6xhZ2FyUzb++CjDbbBk8TUGzQ=
Message-ID: <43e72e890810231840t2b5dd812p50d2325a967e6d4@mail.gmail.com>
Date: Thu, 23 Oct 2008 18:40:27 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Zhang Yanmin" <yanmin.zhang@intel.com>,
       "Shaohua Li" <shaohua.li@intel.com>
Subject: CONFIG_PCIEASPM needed for ASPM?
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know, the question is silly right? I thought so too, but I started
reviewing the code and noticed most of it is just setting up values in
data structures for the kernel's awareness of capabilities, it also
updates the state in case of BIOS foobar, and there is also clock
retraining if possible to reduce latency. Is that it? Did I miss
something or is it really possible for devices to be able to use
L0s|L1 or L1 by just having a BIOS which does things correctly?

That is can our devices be using ASPM without any OS interaction,
without CONFIG_PCIEASPM enabled?

Thanks,

  Luis
