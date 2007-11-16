Return-Path: <linux-kernel-owner+w=401wt.eu-S1761737AbXKPPGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737AbXKPPGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXKPPGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:06:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:45329 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbXKPPGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:06:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dC6IwEA+kVR5H7H+vPT0eAH1PtxARFXtvxTIEdz8LgTfhXcUzP/wzqQUQoTtLKRl1nWwLcyczn2fZYCm69DBfsEThNLMNVcT8Gfpl4xsJKFFnlCaSSgrXDW79Vg5ZELps7mmRG6hDreAKKgfheDsnKQ7yXWv2YkcKva85OZ+2Ss=
Message-ID: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com>
Date: Fri, 16 Nov 2007 16:06:36 +0100
From: "Franck Bui-Huu" <vagabon.xyz@gmail.com>
To: rjw@sisk.pl
Subject: apm emulation driver broken ?
Cc: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

Looking at commit:

	831441862956fffa17b9801db37e6ea1650b0f69
	Freezer: make kernel threads nonfreezable by default

it seems that you broke the apm emulation driver.

You removed PF_NOFREEZE flag setting in apm_ioctl(), which is
definitely not part of the apm kernel daemon but instead is called by
user space proccesses...

I'm just reading this code for the first time so I can be wrong but it
looks like it's not going to work anymore.

Could you confirm ?

		Franck
