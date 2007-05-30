Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbXE3SFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbXE3SFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbXE3SFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:05:22 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:38187 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbXE3SFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YJyBek55X7ZHDjOy8F4T5RacgCrxqMrFN/jVTR8p8b4SGjJJl2ndh9wsU2PJ8pg5Tc8o1bW5TBEIB1EZ4QsicgjlU/v+zeOF6dKkVNCbr9ofJ73DgIviX5zWbFrHIZB2oejxigKr/jCNEtaIOZTcOljR2m+OfY7NEgl7gst9OvE=
Message-ID: <a781481a0705301105n37309182xdf56fb99a3392430@mail.gmail.com>
Date: Wed, 30 May 2007 23:35:17 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Michael-Luke Jones" <mike.luke.jones@gmail.com>
Subject: Re: [-mm] Move zlib compression library to common directory [TAKE TWO]
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, "Mark Adler" <madler@alumni.caltech.edu>,
       jloup@gzip.org
In-Reply-To: <465C5549.4050101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <465C3973.3090303@gmail.com> <465C5549.4050101@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 5/29/07, Michael-Luke Jones <mike.luke.jones@gmail.com> wrote:
>
>
> This patch moves the zlib compression and decompression code
> to a common directory. The zutil.h header, which is not meant
> to be public, is moved from include/linux/ to lib/zlib/.

You could remove the (now pointless) /* WARNING: ... */ comment
from (the now truly private) zutil.h too ...

> In addition, the PRESET_DICT definition from zutil.h, used by
> fs/jffs2/compr_zlib.c is moved to the 'true' public zlib
> header include/linux/zlib.h.

Ugh, I wish you had held on from this patch till the original thread
discussing this reached some conclusion ... from Mark's response
there it does seem PRESET_DICT is clearly an implementation
(and not interface) detail -- which means to me that it must continue
to live in zutil.h (the private header) ... but then, this change is
clearly not so critical either, so it doesn't matter much, I guess.

[ Added zlib authors Mark Adler and Jean-Loup Gailly on this
thread too. ]

Satyam
