Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbXGNEw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbXGNEw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 00:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXGNEws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 00:52:48 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:49481 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbXGNEwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 00:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QyLIpT/u0nwIo+y5Vjs2WEfqAmhbxNfQn48/m81FNDujRk+r+9yLOb3EhaHwmCeMlYf1ykWFFHifHs+93ORdk4/171fYpt4tOzoYsGIk6iSEpPKOZMXsKgnfdBN63nXYSNW3480QoXXHuIpDKsUJdi9tHSKHAe+nWFxRMHZ6nhw=
Message-ID: <4698569A.7010904@gmail.com>
Date: Sat, 14 Jul 2007 13:52:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/61] sysfs: make sysfs_put() ignore NULL sd
References: <11841968512510-git-send-email-gregkh@suse.de>	 <20070712.085047.37780825.yoshfuji@linux-ipv6.org>	 <20070711235529.GA7485@suse.de>	 <20070712.100617.14203407.yoshfuji@linux-ipv6.org>	 <46959958.6080005@gmail.com>	 <a781481a0707121246tc1b62d1qe80db8422e6e26a3@mail.gmail.com>	 <4696FDDC.7050503@gmail.com> <4697078D.4050601@gmail.com>	 <a781481a0707131028m36bf9e1eka20b783b5f350ae3@mail.gmail.com>	 <46983C76.1040406@gmail.com> <a781481a0707132127h31b3c241wbb1a087bf469c006@mail.gmail.com>
In-Reply-To: <a781481a0707132127h31b3c241wbb1a087bf469c006@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Satyam Sharma wrote:
> Anyway, we've wasted enough time and bandwidth discussing this
> (relatively trivial) matter, and I know nobody's mind is changed after
> the end of it all (at least mine won't), so I suggest let's stop. The
> proposed change is in Greg's tree already, and if he's fine with it,
> then there's not much to do about it, is there :-)

I have no problem regenerating the patchset without this allow-NULL
patch but as I said, I see it as an improvement and we'll have to agree
to disagree on that point.  But, if you think NULL get/put() are bad,
please go ahead and change things.  As long as things stay consistent,
I'm okay with, well, even slightly prefer not allowing NULL.

Thanks.  :-)

-- 
tejun
