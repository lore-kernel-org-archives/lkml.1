Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbXGEXDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbXGEXDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbXGEXC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:02:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35217 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbXGEXC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:02:57 -0400
Date: Fri, 6 Jul 2007 00:02:51 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James.Bottomley@SteelEye.com, akpm@linux-foundation.org, jeff@garzik.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] clean gendisk out of scsi ULD structs
Message-ID: <20070705230251.GS21478@ftp.linux.org.uk>
References: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 02:06:36PM -0700, Kristen Carlson Accardi wrote:
> Since gendisk will now become part of struct scsi_device, we don't need
> to store this value in any private data structs where they already store
> scsi_device.  This series cleans up a few drivers which did this.

What the hell?  gendisks are *NOT* supposed to be embedded into other
data structures, you'll screw up the lifetime rules for them.
