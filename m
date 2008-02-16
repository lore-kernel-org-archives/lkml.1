Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYBPRPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYBPRPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYBPROz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:14:55 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:4525 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbYBPROy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:14:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VlLCJliz/bKno+01tx+Od6l3lN/9HJnvYSg585iAAgcktzo2B6YSWMvyFH2/xa3tyzcmQhgWC7FVfpExSIMhPDtCItfbdQC/vevJycQi44NUHRSDXZLEseyriEXL4AJAOP/hslf1oO7F64x8Ms7HYPvOc3fiZ2Ioll9Pul8d01U=
Message-ID: <5a4c581d0802160914m7778cf3av5c01c54374f26f5b@mail.gmail.com>
Date: Sat, 16 Feb 2008 18:14:52 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc2: wpa_supplicant BUGs kernel in rwlock recursion
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fedora 8 / x86, Dell D610, ipw2200

testcase:

1. boot into runlevel 3
2. log on as root on tty1
3. start wpa_supplicant

2.6.25-rc1-git4 is okay
2.6.25-rc2 BUGs dumping stack on console, but nothing gets in /var/log/messages
2.6.25-rc2-git1 BUGs dumping stack on console, ONLY this in /var/log/messages:

Feb 16 16:51:49 sandman kernel: BUG: rwlock recursion on CPU#0,
wpa_supplicant/2342, c0440220

Will now look for changes between -rc1-git4 and -rc2... .config files
 are the same for the two kernels, and available if needed.

I might be able to provide full stack via netconsole, but there's some work
 to do to set it up.

thanks,

--alessandro

 "We act as though comfort and luxury were the chief requirements
   of life, when all that we need to make us really happy is
   something to be enthusiastic about."

   (Charles Kingsley)
