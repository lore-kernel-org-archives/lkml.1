Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbYKENAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbYKENAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYKENAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:00:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:1890 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYKENAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:00:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=R8XlDEYLoH0L4rCd8W1iGu4O5Yx3IgSB5sG5PtJgx+w9CWNWQ37c/N3KmFl5UACOj4
         n0bOhK7ll8b7XxVvZj1obHVBF5duOW/sSFNfwPSFjGcpC5O+30g1+SlK6joTpZ3qyFi3
         XCTc1pznMRXGmRWernvzwd60nFVj0xMQE8VVQ=
Message-ID: <491198E4.8080306@panasas.com>
Date: Wed, 05 Nov 2008 15:00:20 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu,
       fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sami.Iren@seagate.com, pw@padd.com
Subject: Re: [PATCH 03/18] libosd: OSDv1 Headers
References: <491073BB.4000900@panasas.com> <1225817046-5946-1-git-send-email-bharrosh@panasas.com> <20081104111037.bcae04e5.akpm@linux-foundation.org> <20081104194240.GC16036@logfs.org>
In-Reply-To: <20081104194240.GC16036@logfs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Tue, 4 November 2008 11:10:37 -0800, Andrew Morton wrote:
>> etc, etc, etc.   Please review all that.
> 
> One easy way to review 98% is to include the header in an otherwise
> empty foo.c and compile that.  The remaining 2% are hidden behind
> different config options and architectures.  Although your header may be
> fine on that front.
> 
> Jörn
> 

I have done just that. It's an old habit of mine. The very first
#include in osd_initiator.c is osd_initiator.h precisely for that.
So it's not just a one time test it's always tested.

Thanks
Boaz
