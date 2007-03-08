Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbXCHQD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbXCHQD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbXCHQD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:03:26 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:46673 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752433AbXCHQDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:03:24 -0500
Subject: Re: [PATCH] [scsi]: Add offline state checking while dispatch a
	scsi cmd
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: akpm@osdl.org, dgilbert@interlog.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, haobo.zhou@oracle.com
In-Reply-To: <20070308092207.GA17141@joejin-pc.cn.oracle.com>
References: <20070308092207.GA17141@joejin-pc.cn.oracle.com>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 08:02:39 -0800
Message-Id: <1173369759.3683.1.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 17:22 +0800, Joe Jin wrote:
> While a scsi device hw error occured, device's status maybe setting 
> to SDEV_OFFLINE, So at scsi_dispatch_cmd function, we should checking
> if device have offline, if yes, do nothing and just return error to
> user directly.

What's the error you're trying to fix?  scsi_dispatch_cmd() is only
called from scsi_request_fn() which already has an equivalent of this
check in it just prior to calling dispatch.

James


