Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYGNHRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYGNHRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbYGNHQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:16:16 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:52578 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbYGNHQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nF/Phn9Op5DXWuKvBCVQoqI1CndrI0zrY9a4+Ij+sc6JNCFjoFRmJcWiC7E8kz7lAu
         53jPiCDdTGNvW2uA9cgmswh6D92K/J1YWhNR2B4AIRIRBeb/L3JShktgl9JwLN83Yusi
         6UZtbLfTpcW2Oy/VVjvQQ4PRdYk6dT/ppr6SA=
Message-ID: <487AFD2E.7070400@gmail.com>
Date: Mon, 14 Jul 2008 16:15:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com,
       bharrosh@panasas.com, greg.freemyer@gmail.com,
       linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca,
       viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCHSET 2.6.26] block: implement extended devt, take #2
References: <1216019534-29977-1-git-send-email-tj@kernel.org>
In-Reply-To: <1216019534-29977-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, missed one prerequisite patch.

Tejun Heo wrote:
>   v2.6.26 (bce7f793daec3e65ec5c5705d2457b81fe7b5725)
> + [1] RCU-implement-rcu_read_[un]lock_preempt
> + [2] block-fix-block_class-iteration-locking
> + [3] block-allow-deleting-zero-lenght-partition
> + [4] block-update-add_partition-error-handling
+ [5] sd-update-index-allocation-and-use-ida

> [L] http://thread.gmane.org/gmane.linux.kernel/701825
> [1] http://article.gmane.org/gmane.linux.kernel/706149
> [2] http://article.gmane.org/gmane.linux.kernel/706152
> [3] http://article.gmane.org/gmane.linux.kernel/706153
> [4] http://article.gmane.org/gmane.linux.kernel/706154
[5] http://article.gmane.org/gmane.linux.scsi/43109

The git tree has everything included.

Thanks.

-- 
tejun
