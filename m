Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbXLNPy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbXLNPy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbXLNPyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:54:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:45142 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbXLNPyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VNM6LpKfYJUglyb7h+DjeI8fxZNIQYOxZhoc2p1PvHMDRgUqrwWSm0x4Sy7obubtvOiGdRpmQjy9WvbJ31wNlyZn2wCCbn1NMsmXNuSg5DWA4NTqxlRvTZSmE3sGO3q5S48DNhZd4BmEmwDRS22KTiMOSpN9T6x4R/c6G3RE0Wg=
Message-ID: <4762A721.7080400@gmail.com>
Date: Sat, 15 Dec 2007 00:54:09 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Greg KH <gregkh@suse.de>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
References: <20071213123333.GA16905@linux.vnet.ibm.com> <20071213132326.GC16905@linux.vnet.ibm.com> <20071213151847.GB5676@linux.vnet.ibm.com> <20071213162936.GA7635@suse.de> <20071213164658.GA30865@linux.vnet.ibm.com> <20071213175423.GA2977@linux.vnet.ibm.com> <476295FF.1040202@gmail.com> <20071214154711.GD23670@linux.vnet.ibm.com>
In-Reply-To: <20071214154711.GD23670@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
> XXX sysfs_page_cnt=1

Hmm.. so, sysfs r/w buffer wasn't the culprit.  I'm curious what eats up
all your low memory.  Please do the following.

1. Right after boot, record /proc/meminfo and slabinfo.

2. After or near OOM, record /proc/meminfo and slabinfo.  This can be
tricky but if your machine reliably OOMs after 10mins, run it for 9mins
and capturing the result should show enough.

Thanks.

-- 
tejun
