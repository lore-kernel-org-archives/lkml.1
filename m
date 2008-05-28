Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYE1X5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYE1X5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 19:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYE1X51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 19:57:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:61524 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYE1X5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 19:57:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=E027/XBP3TAtzX0iglvHOGK3UM99MzP1AwqSZOeD5mx7BWCVEksiijioskL2Iv30TmUDoOdT08Yp/hB5jUk/dFnkFa94BzpY7mda642NEeTM2iwqCpWwtVd/h1XluSSdTU3HgDybtdtQv1OVvamhPjlFADSbDl4hFPrN16PM0uE=
Message-ID: <75b66ecd0805281657k7b988bf1qa46e806810da0c17@mail.gmail.com>
Date: Wed, 28 May 2008 19:57:11 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: Raz <raziebe@gmail.com>
Subject: Re: mmap over HPET - 32 bit wrap arround
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <5d96567b0805281519v7ee18eb0l27f2e4edc18af01c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83CA05F64804AF43B8F733C4ABDFAA5101384F73@mail1.bitband.com>
	 <83CA05F64804AF43B8F733C4ABDFAA5101384FA4@mail1.bitband.com>
	 <5d96567b0805281519v7ee18eb0l27f2e4edc18af01c@mail.gmail.com>
X-Google-Sender-Auth: 5095e11c8f888cbd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 6:19 PM, Raz <raziebe@gmail.com> wrote:
> I am wondering wether someone can explain how hpet behaves. The bellow
> is a short program that reads from a mmaped /dev/hpet the time. I am
> running it and it looks that afer ~296 seconds the counter resets . I
> AM RUNNING  64bi KERNEL(2.6.18-8.el5)  and reading a 64BIT VARIABLE.
> my hpet is 14MHZ, so I  am guessing a 32bit wraparound ( ~296 * 14Mhz
> ) =  MAX_INT . but why ?
>

HPET counter can be either 32 or 64 bit.  Check COUNT_SIZE_CAP.

http://www.intel.com/hardwaredesign/hpetspec_1.pdf

Lee
