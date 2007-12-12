Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbXLLWBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbXLLWBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXLLWBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:01:13 -0500
Received: from emulex.emulex.com ([138.239.112.1]:60482 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXLLWBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:01:12 -0500
Message-ID: <476059FD.2070300@emulex.com>
Date: Wed, 12 Dec 2007 17:00:29 -0500
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: scsi/lpfc/lpfc_attr.c: bogus code
References: <20071211222055.GE14204@stusta.de>
In-Reply-To: <20071211222055.GE14204@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2007 22:00:48.0000 (UTC) FILETIME=[73B0E800:01C83D0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has already been fixed. It's in our 8.2.3 patches, which were merged into
James's scsi-misc-2.6 tree at the beginning of November, and targeted for 2.6.25.

-- james s


Adrian Bunk wrote:
> Commit 2e0fef85e098f6794956b8b80b111179fbb4cbb7 added the folowing code 
> to drivers/scsi/lpfc/lpfc_attr.c that was most likely not intended to be 
> dead code:
> 
> <--  snip  -->
> 
> ...
> lpfc_state_show(struct class_device *cdev, char *buf)
> {
> ...
>                 switch (vport->port_state) {
>                         len += snprintf(buf + len, PAGE_SIZE-len,
>                                         "initializing\n");
>                         break;
> ...
> 
> <--  snip  -->
> 
> Spotted by the GNU C compiler version 3.3.
> 
> cu
> Adrian
> 
