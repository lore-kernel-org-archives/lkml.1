Return-Path: <linux-kernel-owner+w=401wt.eu-S1765118AbXGQAwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765118AbXGQAwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbXGQAw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:52:29 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:25870 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbXGQAw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:52:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ev/3rZsjw+Dagqw2J6c9MI5RYL0ZnVzVfAmL01/db2uOll0ahljux5Pd3GCj9uBzKkgWEVO2EUsmrujS3JvvWwPC/nxULWAQjnKr3D+oQTX4g9G/MJ82jcSX+n6tZRvKxC/i3jW6PZWASw6XGFAzFfl/GYEsxz8ts+EYxrqxvHY=
Message-ID: <a781481a0707161752v3dcb794cvc9b9c2f8812def57@mail.gmail.com>
Date: Tue, 17 Jul 2007 06:22:25 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: block/bsg.c
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Jens Axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <20070716165706.348f6bbf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>

CONFIG_BLK_DEV_BSG=y
CONFIG_SCSI=m

block/built-in.o: In function `bsg_init':
block/bsg.c:1097: undefined reference to `scsi_register_interface'
make: *** [.tmp_vmlinux1] Error 1

on latest -git.

Satyam
