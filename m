Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZGPHyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZGPHyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZGPHyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:54:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:34261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZGPHyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:54:52 -0400
Message-ID: <4A5EDCB8.1010003@kernel.org>
Date: Thu, 16 Jul 2009 16:54:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH v2]: New implementation of scsi_execute_async()
References: <4A563368.5040407@vlnb.net> <4A5CAFB5.1000901@vlnb.net> <4A5D9C46.2000002@panasas.com>
In-Reply-To: <4A5D9C46.2000002@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Jul 2009 07:54:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
> It looks to me that perhaps you did not understand Tejun's code
> His code, as I remember, was on the bio level, but here you
> are duplicating what is done in bio level.

I think he looked at my mess :-) and decided it would be cleaner to
implement kernel sg mapping completely separately from user mapping.
Maybe it is, I'm not sure.  I sure hope not tho.

Thanks.

-- 
tejun
