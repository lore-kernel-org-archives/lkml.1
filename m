Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbXFAWlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbXFAWlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXFAWlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:41:10 -0400
Received: from eos.fwall.u-szeged.hu ([160.114.120.248]:40900 "EHLO
	eos.fwall.u-szeged.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbXFAWlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:41:09 -0400
Date: Sat, 2 Jun 2007 00:41:03 +0200 (CEST)
From: Geller Sandor <wildy@petra.hos.u-szeged.hu>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: HPT374 IDE problem with 2.6.21.* kernels
In-Reply-To: <46608EFE.1030202@ru.mvista.com>
Message-ID: <Pine.LNX.4.62.0706020035200.19399@petra.hos.u-szeged.hu>
References: <Pine.LNX.4.62.0705301112170.1260@petra.hos.u-szeged.hu>
 <20070601134607.ce4a37bd.akpm@linux-foundation.org> <46608764.5060807@ru.mvista.com>
 <Pine.LNX.4.62.0706012311320.16639@petra.hos.u-szeged.hu> <46608EFE.1030202@ru.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SZTE-local: YES
X-SZTE-HU-local: YES
X-SZTE-AVcheck: YES
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007, Sergei Shtylyov wrote:

>> The log of a typical IDE reset is available here:
>
>> http://petra.hos.u-szeged.hu/~wildy/syslog.gz
>
>> This was the worst case: the IDE bus was resetted during the system boot.
>
>   Could you try setting HPT374_ALLOW_ATA133_6 to 0 in 
> drivers/ide/pci/hpt366.c and rebuild/reboot the kernel?


Hi Sergei,

This looks promising. Using a vanilla 2.6.22-rc3 I was able to reproduce 
the problem within a few seconds. With the above modification the machine 
is running under heavy disk I/O without problems since 30 minutes...

Regards,

   Geller Sandor <wildy@petra.hos.u-szeged.hu>
