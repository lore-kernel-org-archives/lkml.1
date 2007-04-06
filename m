Return-Path: <linux-kernel-owner+w=401wt.eu-S1767796AbXDFPvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767796AbXDFPvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767794AbXDFPvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:51:36 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:50841 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932975AbXDFPvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:51:35 -0400
Subject: Re: CONFIG_SCSI_WAIT_SCAN=m
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <Pine.LNX.4.64.0703271658380.26754@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703271658380.26754@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 10:51:10 -0500
Message-Id: <1175874670.3677.14.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, was waiting for a reply on this one ... didn't realise it hadn't
cc'd linux-scsi ...

James

On Tue, 2007-03-27 at 17:25 +0100, Hugh Dickins wrote:
> I'm not using an initrd, most of my kernel is builtin,
> just a few modules for occasional filesystems.
> 
> CONFIG_MODULES=y
> CONFIG_SCSI=y
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
> 
> 2.6.21-rc5-mm2 VFS panics unable to find my root on /dev/sda2,
> but boots okay if I change drivers/scsi/Kconfig to "default y"
> instead of "default m" for SCSI_WAIT_SCAN.
> 
> I'm sure that's not the right fix, but I don't know what is.
> 
> I've had no trouble with SCSI_SCAN_ASYNC=y until now: I could
> turn it off, but others may have trouble with the same regression.
> 
> Hugh

