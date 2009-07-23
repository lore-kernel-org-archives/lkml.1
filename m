Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZGWOhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZGWOhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZGWOhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:37:54 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:60209 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbZGWOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:37:52 -0400
Date: Thu, 23 Jul 2009 07:37:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] implement uid mount option for ext2 and ext3
Message-Id: <20090723073743.6aeed77e.randy.dunlap@oracle.com>
In-Reply-To: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A6875BA.00ED:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 13:36:29 +0200 Ludwig Nussel wrote:

> Hi,
> 
> When using 'real' file systems on removable storage devices such as
> hard disks or usb sticks people quickly face the problem that their
> Linux users have different uids on different machines. Therefore one
> cannot modify or even read files created on a different machine
> without running chown as root or storing everything with mode 777.
> Simple file systems such as vfat don't have that problem as they
> don't store file ownership information and one can pass the uid
> files should belong to as mount option.
> 
> The following two patches (for 2.6.31-rc4) therefore implement the
> uid mount option for ext2 and ext3 to make them actually useful on
> removable media. My implementation just writes uid 0 to disk for
> files that are owned by the specified user. In read direction files
> with uid 0 appear as being owned by the specified user.
> 
> In an ideal world this would probably be implemented as vfs feature
> rather than having it in every single file system.
> 
> Anyways, AFAICT the method works just fine for ext2. I'm not sure
> about the ext3 patch though as ext3 has that ext3_setattr() function
> for journaling. I don't know if the uid should better be mangled
> there instead.

Hi,
Please document the mount options in Documentation/filesystems/ext?.txt .

Thanks.
---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
