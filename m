Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYIAGEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYIAGEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYIAGD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:03:59 -0400
Received: from pow-web.powerkom-dd.de ([212.80.237.131]:43487 "EHLO
	mail.powerkom-dd.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927AbYIAGD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:03:58 -0400
X-Greylist: delayed 2310 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2008 02:03:58 EDT
Subject: Re: [Iscsitarget-devel] [RFC] future IET development
From: Arne Redlich <agr@powerkom-dd.de>
To: rae l <crquan@gmail.com>
Cc: "Ross S. W. Walker" <RWalker@medallion.com>,
       iscsitarget-devel <iscsitarget-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, unh-iscsi-checkins@lists.sourceforge.net
In-Reply-To: <91b13c310808311036k2792d1fqaeb94a814f0bee81@mail.gmail.com>
References: <1218829367.3145.31.camel@blackadder>
	 <91b13c310808282007u7fc90eeah2b27661a7a5f595@mail.gmail.com>
	 <E2BB8074E5500C42984D980D4BD78EF9022A73D4@MFG-NYC-EXCH2.mfg.prv>
	 <91b13c310808311036k2792d1fqaeb94a814f0bee81@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 07:25:18 +0200
Message-Id: <1220246718.8763.31.camel@blackadder>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 01.09.2008, 01:36 +0800 schrieb rae l:

> Have you read the Documentation/ of the kernel?
> Didn't you know the benefits of getting the kernel code into the main
> kernel tree?
> 
> Here is some reasons from Documentation/stable_api_nonsense.txt:

[...]

You can safely assume that we're aware of the benefits of having the
code in the kernel, but it will not happen. It does not make much sense
to merge an iSCSI target into the kernel when there are generic target
frameworks around that can also support different transports such as FC,
FCOE. So there's not the remotest chance of getting IET merged.

Currently there's already STGT code in the kernel. It's basically an
interface for kernel drivers such as FC, however most processing and
many drivers (iSCSI, iSER, FCOE, ...) are done in userspace. And there's
SCST. It also provides several transports and storage backends. It's
mostly implemented in kernel space. Recently there's some movement to
get it into the kernel.

If you're interested in more details just search the linux-scsi and the
respective project's list archives.

> Indeed, in sometimes I observed IET kernel module not very stable on
> the latest 2.6.26 and 27-rcX kernels, sometimes it's kernel oops
> after serveral stop-ietd-unload-ko-load-ko-start-ietd loops, but not
> always reproducible, I'm still tracing on it;

Please post the oops.

Thanks,
Arne

