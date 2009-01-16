Return-Path: <linux-kernel-owner+w=401wt.eu-S1765527AbZAPWnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765527AbZAPWnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZAPWnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:43:12 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37883 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZAPWnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:43:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YwR/qfyTpoF1++bSP5ysZXcXW3yJ0n/Rrh8+bRCRd/eEuJ+d69msw2X+ivw3c+EmwT
         n56HOarYpzZoQcA7YVNKZngL5Ew2IGx7w6qiRkhZhw6gOi+b8l8/8tkH0YPQEO2l1Vu0
         YMO/uBQSbsN7pUNfRwqCdqZeBifRki8t0Sqws=
Message-ID: <bcb3ef430901161443y5843d951m1cdee28dd588d006@mail.gmail.com>
Date: Fri, 16 Jan 2009 23:43:08 +0100
From: MartinG <gronslet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Suspend/resume works in 2.6.29-0.19.rc0.git9.fc11.i686, but fails in later versions
In-Reply-To: <20090116085326.GC4795@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bcb3ef430901150110nc4ced93w50c662ac512f8552@mail.gmail.com>
	 <20090116085326.GC4795@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 9:53 AM, Pavel Machek <pavel@suse.cz> wrote:
> Can you boot non-working kernel, and try "cd /sys/devices/system/cpu;
> echo 0 > cpu1/online; echo 1 > cpu1/online" ?
>
> If it breaks, try just doing "echo 0 > online" followed by s2ram. That
> should work.

Ok, thanks for the reply. This is what I've tried (I have a single
core (old) cpu):
# uname -r
2.6.29-0.35.rc1.git4.fc11.i686
# cd /sys/devices/system/cpu
# find .|grep online
./online
# cat online
0
# echo 0 > online; echo 1 > online
-bash: online: Permission denied
-bash: online: Permission denied
# chmod +rw online
# echo 0 > online; echo 1 > online
-bash: echo: write error: Input/output error
-bash: echo: write error: Input/output error

Yep, I am a bit confused - any hints appreciated!

-MartinG
