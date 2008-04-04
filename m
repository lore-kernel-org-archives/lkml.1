Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYDDQoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYDDQoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 12:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYDDQo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 12:44:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:41436 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYDDQo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 12:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=QXloplfFy+cEztAoQy9W0xCJ4AlfPMXaQmhb29J+WNO+cbllN9WBDBseToHPf3tbb/f0xL43sfOkXpmgO98OKBs5Au3dPubPFzhXUjG1OrlSKIXn/pvvKF7MjPbBm3y7at8NRnoG6vhXfH+3F8IZJ9pFr2o3cCmdGGR4iDlZ970=
Message-ID: <47F65AE6.4050500@googlemail.com>
Date: Fri, 04 Apr 2008 18:44:22 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Gabriel C <crazy@frugalware.org>
Subject: kernel/time.c: integer constant is too large for 'long' type warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with CONFIG_HZ_300=y I see these warnings :

...

kernel/time.c: In function 'msecs_to_jiffies':                                                                                                               
kernel/time.c:472: warning: integer constant is too large for 'long' type                                                                                    
kernel/time.c: In function 'usecs_to_jiffies':                                                                                                               
kernel/time.c:487: warning: integer constant is too large for 'long' type

...


I think this was introduced by :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=bdc807871d58285737d50dc6163d0feb72cb0dc2

If you need more infos let me know.


Regards,

Gabriel
