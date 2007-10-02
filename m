Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbXJBSqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbXJBSqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXJBSqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:46:07 -0400
Received: from ispmxfep02-srv.windstream.net ([166.102.165.158]:36430 "EHLO
	ispmxfep02-srv.windstream.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbXJBSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:46:06 -0400
Date: Tue, 2 Oct 2007 14:46:03 -0400 (EDT)
From: Burton Windle <bwindle@fint.org>
X-X-Sender: bwindle@postal
To: Adrian Bunk <bunk@kernel.org>
cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Sumant Patro <sumant.patro@lsi.com>,
       James Bottomley <James.Bottomley@SteelEye.com>, megaraidlinux@lsi.com,
       linux-scsi@vger.kernel.org
Subject: Re: 2.6.23-rc9 boot failure (megaraid?)
In-Reply-To: <20071002181518.GC10852@stusta.de>
Message-ID: <Pine.LNX.4.64.0710021442450.6275@postal>
References: <Pine.LNX.4.64.0710021242510.6275@postal> <20071002181518.GC10852@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Adrian Bunk wrote:

> Cc's added, the complete bug report is at
>  http://lkml.org/lkml/2007/10/2/243
>
> On Tue, Oct 02, 2007 at 12:48:26PM -0400, Burton Windle wrote:
>> 2.6.23-rc9 fails to boot for me; 2.6.22.9 works fine.
>>
>> System is a Dell Poweredge with PERC 2/DC with RAID1 volume.
>> ...
>
> Thanks for your report.
>
> Does reverting the commit below fix the problem?
>
> cu
> Adrian
>
>
> commit 3f6270ef76f2ce5c134615a470685d6c2a66c07e
> Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date:   Mon May 14 20:17:27 2007 +0900
>

Confirmed; reverting the above (snipped) patch does fix the issue.

-- 
Burton Windle                           bwindle@fint.org

