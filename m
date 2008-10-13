Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYJMFSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYJMFSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 01:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYJMFSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 01:18:23 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:17412 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYJMFSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 01:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ditt4q94wOXdqv25IG/YLvhsOuf5Fy9ERzTA/AErOFZ2sLsmZ4SMR5JUX128Rx3bAU
         2qVlV9CNGR4sU8mQYGvXMgi6cxfhp9BcG8uGmTN8v0fREEyQ2SZ+nVR/P22gjgEcI9cM
         tL08LO0eCLEA1HbsIx5Lmv+IFTPIVOrm1g14E=
Message-ID: <48F2D9A8.1030502@gmail.com>
Date: Mon, 13 Oct 2008 14:16:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Christian Mueller <Christian.Mueller@wdc.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>	<48EBFE9B.9070503@gmail.com> <18674.4081.839329.116533@harpo.it.uu.se>
In-Reply-To: <18674.4081.839329.116533@harpo.it.uu.se>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> - smartctl -n standby waking Linda's disks from standby is probably
>   a disk firmware issue or a smartctl issue. I see no evidence that
>   sata_promise is to blame for that.

/me agrees.  I think it's most likely a problem in the firmware.

> - hardreset in sata_promise seems broken. I'll take a closer look
>   at that in about a week's time (I'll be busy with other work the
>   next couple of days).

This looks like a rather serious problem, so please take a look at
this.  Also, after the drive went down, does unplugging and replugging
the signal cable fix the problem, if not does doing the same thing
with the power cable make any difference?

Thanks.

-- 
tejun
