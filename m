Return-Path: <linux-kernel-owner+w=401wt.eu-S965289AbXDHCSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289AbXDHCSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 22:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966039AbXDHCSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 22:18:53 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:39931 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965289AbXDHCSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 22:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Sd3q/PPgZ+1LxfGQW9Y6OHvjN9CyEuv+de5cIw8b0DIeOy5t+2t1Psx5lg8ObthMwm3cEYoXAnTNYrS4Q2hMzvUIdPUCrBEP+7HTbojXljTIy9XEvmiLtSgnNwblRaFvoFY9gSsooW4t5IrWWx3LJihcll88wzJjOy1etpxZnwk=
Message-ID: <46185105.8090007@gmail.com>
Date: Sun, 08 Apr 2007 11:18:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: gregkh@suse.de
CC: maneesh@in.ibm.com, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] sysfs: kill attribute file orphaning
References: <1175934228125-git-send-email-htejun@gmail.com>
In-Reply-To: <1175934228125-git-send-email-htejun@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Now that sysfs_dirent can be disconnected from kobject on deletion,
> there is no need to orphan each attribute files.  All [bin_]attribute
> nodes are automatically orphaned when the parent node is deleted.
> Kill attribute file orphaning.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

This isn't really true.  An attribute can belong to different module
from the kobj's and we still need per-attribute orphaning as the backing
methods can go away.  Please ignore patch 13, 14 of this patchset.

Thanks.

-- 
tejun
