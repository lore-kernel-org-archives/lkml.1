Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYANVoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYANVoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYANVoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:44:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:1750 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYANVoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=x62UgsLpTM97vJQbX8hzymqX4U9j+G1V4uG3WPS9sryxFPy/tXlSIS0KImzca+Kn3AR7gykW325CF3LBnAwGlt4ep1PA+5Tvmnb8FNjDNCkGoWyPQPmkKXWC9jWuFfHPZCHHS8CcNa+bw73FTfkD3LmvucrAVFFXM4CC1wgbN6k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 0/12] ide-floppy redux v2.5
Date: Mon, 14 Jan 2008 22:38:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801142238.17282.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 13 January 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here are the remaining patches which had issues to be worked out. I decided
> to keep the Flexible Disk Page and Capacity Descriptor in
> idefloppy_floppy_t for the sake of the two printk calls for which they are
> used. Otherwise, we'll be changing long-known driver behavior and this won't
> be acceptable. I'll audit the driver to see whether rq_data_dir() can replace
> the PC_WRITING flag completely and get rid of that one too.

Thanks, I applied patches #1-9 and #11, #10 needs small corrections and will
be applied once they are addressed (#12 is fine but since it depends on #11
it has also to wait a bit more).

> By the way, I have an Iomega ZIP 100 drive somewhere in my hardware pile and
> will do some testing with the "new" :) driver just in case.

This would be great. :)

Cheers,
Bart
