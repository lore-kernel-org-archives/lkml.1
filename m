Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXEFKPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXEFKPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 06:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933591AbXEFKPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 06:15:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:22221 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbXEFKPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 06:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DxZ3rgani794mUFHz9Gl7eNjy2jbsleRwSupS5NNW0U6DSz/VFdWYk2P5peKUSn+/Mf+5s8ur/XFDbBRgrsmqVASkRJFTTJPixoZAqOiqqP7SwSTMwYDG9HNzlLEFXI1+6f1AzpI24H62MXEo//CVTn3ZO1qwE185CDOqYA05QY=
Message-ID: <463DAAC6.3060300@gmail.com>
Date: Sun, 06 May 2007 12:15:34 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 0/7] Asynchronous Notification for ATAPI devices (v2)
 - resend
References: <20070504111222.c2e373cf.kristen.c.accardi@intel.com>
In-Reply-To: <20070504111222.c2e373cf.kristen.c.accardi@intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> This patch series implements Asynchronous Notification (AN) for SATA
> ATAPI devices as defined in SATA 2.5 and AHCI 1.1 and higher.  Drives
> which support this feature will send a notification when new media is
> inserted and removed, preventing the need for user space to poll for
> new media.  This support is exposed to user space via a flag that will
> be set in /sys/block/sr*/capability_flags.  If the flag is set, user
> space can disable polling for the new media, and the genhd driver will
> send a KOBJ_CHANGE event with the envp set to MEDIA_CHANGE_EVENT=1.
> 
> Note that this patch only implements support for directly attached
> drives - AN with drives attached to a port multiplier requires 
> additional changes.

No objection from me.  BTW, you're not setting ATA_FLAG_AN anywhere in
the patch series, will that be a separate patch?

-- 
tejun
