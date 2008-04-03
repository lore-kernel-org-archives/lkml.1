Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbYDCPTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbYDCPTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbYDCPT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:19:26 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:4309 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785AbYDCPTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:19:25 -0400
Subject: Re: kernel BUG at drivers/block/ub.c:820!
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com,
       jens.axboe@oracle.com, zaitcev@redhat.com, m-ikeda@ds.jp.nec.com
In-Reply-To: <20080403.110825.07645490.k-ueda@ct.jp.nec.com>
References: <1207212156.5602.5.camel@localhost>
	 <20080403.110825.07645490.k-ueda@ct.jp.nec.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 03 Apr 2008 17:18:31 +0200
Message-Id: <1207235911.9155.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kiyoshi,

On Thu, 2008-04-03 at 11:08 -0500, Kiyoshi Ueda wrote:
> I believe the patch from Pete fixes this BUG():
>     http://marc.info/?l=linux-usb&m=120613888005382&w=2
> 
> Could you try that?

Just tested the patch and it indeed fixes the bug.

> Original ub driver was probably ignoring bio completion on BLOCK_PC,
> and I missed the conversion to blk_end_request for BLOCK_PC.
> Sorry about that.

Could we push this upstream for 2.6.25? It is a regression, I would
prefer to have a 2.6.25 that doesn't panic my machine when I attach a
USB stick..

Anyway, thanks for the patch. For now my machine is happy again :-)

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


