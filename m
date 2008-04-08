Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbYDHEBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbYDHEBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 00:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYDHEB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 00:01:29 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:26027 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYDHEB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 00:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gmZvWlIbzBNF2gVqb2LCMU2ozw/FeZqgumB0S/X0ZSk4GeFIGkG5znPoG6bQ6fUe4Ntv+KV20zl1irwhFJvB5lipu3lbuqQgb4PfXi9qygAzzQaZEqBMOcg6SJFh114HCPqOrCCpo95/9Yp5wd/Kvll0iSjXxrQd+FtbuS28fjs=
Message-ID: <f17812d70804072101u1244c864s2f8d2ec1c9f96239@mail.gmail.com>
Date: Tue, 8 Apr 2008 12:01:25 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] pxafb: add smartpanel support
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 4 patches as listed below:

0001 - pxafb: introduce lcd_{read,write}l() to wrap the __raw_{read,write}l()
0002 - pxafb: use completion for LCD disable wait code
0003 - pxafb: move parallel LCD timing setup into dedicate function
0004 - pxafb: preliminary smart panel interface support

The actual support for the smartpanel interface is done by patch 0004, the
patches 0001-0003 are mainly cleanup ones.

The smartpanel interface supports LCD panels with internal buffers,
sometimes known as remote framebuffer.

The next step work will be to introduce an "struct pxafb_output" to
abstract two different output interface supported: the parallel and
the smartpanel, after these patches are merged.

-- 
Cheers
- eric
