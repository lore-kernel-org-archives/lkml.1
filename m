Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbZD3BO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbZD3BO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZD3BOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:14:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:51167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbZD3BOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:14:46 -0400
Message-ID: <49F8FB33.8020803@kernel.org>
Date: Thu, 30 Apr 2009 10:13:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
References: <1233456951-992-1-git-send-email-tj@kernel.org>
In-Reply-To: <1233456951-992-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 01:13:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> This patchset implements alt_size, which is a size hint to the users
> of a block device.  It's primarily to communicate the BIOS (HPA) size
> on ATA devices to userland, so that dmraid can consider it when trying
> to figure out BIOS raid layout.  This is critical as dmraid can be
> tricked into assemblying the wrong raid when fed with the unlocked
> size and if the disk content is right (or, rather, wrong) and good
> number of distros are shipping with ignore_hpa=1 as default.

PING.

-- 
tejun
