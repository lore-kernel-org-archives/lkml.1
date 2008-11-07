Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYKGEhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYKGEhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKGEhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:37:23 -0500
Received: from senator.holtmann.net ([87.106.208.187]:35225 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYKGEhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:37:20 -0500
Cc: Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <2AADE700-38A1-48BC-B586-9962AAC38147@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1226020422.2604.148.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: iwlagn: wrong command queue 31, command id 0x0
Date: Fri, 7 Nov 2008 05:37:18 +0100
References: <1225944979.3792.3.camel@calx> <1226020422.2604.148.camel@debian.sh.intel.com>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yi,

>> As of 75fa67706cce5272bcfc51ed646f2da21f3bdb6e, I'm seeing this:
>
> On which git repo? I couldn't find the commit on either linux-2.6 or
> wireless-testing/-2.6.

don't bother trying to track down the exact commit. This bug has been  
introduced sometime between 2.6.26 and 2.6.27 and was originally a BUG  
that crashed your machine. My last working kernel without this problem  
was the Ubuntu 8.04 kernel.

So starting with 2.6.28-rc1, Johannes turned the BUG into a WARN_ON  
and now we do actually see the issue and the code in question. Check  
kerneloops.org for reference since I did post all of my warnings there.

Regards

Marcel

