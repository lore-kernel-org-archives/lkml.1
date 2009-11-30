Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZK3X0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZK3X0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZK3X0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:26:43 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:64919 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZK3X0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:26:43 -0500
X-Greylist: delayed 1788 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 18:26:42 EST
To: James.Bottomley@suse.de
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.32-rc8
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1259620194.11762.137.camel@mulgrave.site>
References: <1259620194.11762.137.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091201080346W.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 01 Dec 2009 08:03:46 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 17:29:54 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> This is a set of miscellaneous (but small) fixes for SCSI.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
> 
> Alexey Kuznetsov (1):
>       fix crash when disconnecting usb storage
> 
> James Bottomley (1):
>       fix async scan add/remove race resulting in an oops
> 
> Martin K. Petersen (1):
>       sd: Return correct error code for DIF
> 
> The diffstat is:
> 
>  drivers/scsi/hosts.c       |    2 -
>  drivers/scsi/scsi_scan.c   |   18 ++----------
>  drivers/scsi/scsi_sysfs.c  |   63 +++++++++++++++++++--------------------------
>  drivers/scsi/sd_dif.c      |    2 -
>  include/scsi/scsi_device.h |    1 
>  5 files changed, 34 insertions(+), 52 deletions(-)

Can you add the tape driver fix?

http://marc.info/?l=linux-scsi&m=125919508329412&w=2
