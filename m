Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZCRKGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZCRKGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 06:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZCRKF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 06:05:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54778 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZCRKFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 06:05:55 -0400
Date: Wed, 18 Mar 2009 03:05:00 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Sachin Sant <sachinp@in.ibm.com>
cc: jfs-discussion@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, shaggy@austin.ibm.com
Subject: Re: [Jfs-discussion] [BUG/JFS/2.6.29-rc8] kernel BUG at
 fs/mpage.c:473!
In-Reply-To: <49BDFB4F.7040405@in.ibm.com>
Message-ID: <alpine.DEB.2.01.0903180259110.16244@bogon.housecafe.de>
References: <49BDFB4F.7040405@in.ibm.com>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/gR9CLfBtxe0Fm18Z4wIXfLm/8W663Aq3Uirk
 ri3mFJSwgTYwO47RNDoqUYL9OvOzKlp4SwgvfCz/CfPI4dLaCH
 +9X8n5dFWdKFg95ctlmfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Sachin Sant wrote:
> autorun: reading command 85 /usr/local/autobench/scripts/autobench.dat
> autorun: run test fsstress -d $scratchdir -l $iterations: command read
> autorun: run test fsstress -d /mnt/tmp -l 1: was expanded
> 03/15/2009-19:36:37 processing command: (1) 'run test fsstress -d /mnt/tmp -l 1'

How many iterations were really run to hit this BUG? When I specify "-l 
1", fsstress[0] comes back instantly (and no error of course)...

Thanks,
Christian.

[0] http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/testcases/kernel/fs/fsstress/
-- 
Bruce Schneier's passphrase is used to etch diamonds
