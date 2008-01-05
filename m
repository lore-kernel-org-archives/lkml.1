Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYAEEMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYAEEMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 23:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYAEEMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 23:12:33 -0500
Received: from mail.clusterfs.com ([74.0.229.162]:46104 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbYAEEMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 23:12:32 -0500
Date: Fri, 4 Jan 2008 21:12:28 -0700
From: Andreas Dilger <adilger@sun.com>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Mathieu Segaud <mathieu.segaud@regala.cx>, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Message-ID: <20080105041228.GP3351@webber.adilger.int>
Mail-Followup-To: Richard Knutsson <ricknu-0@student.ltu.se>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477E379F.4000103@student.ltu.se>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 04, 2008  14:41 +0100, Richard Knutsson wrote:
>>  @@ -54,6 +54,6 @@ int __ext4_journal_dirty_metadata(const char *where,
>>  {
>>  	int err = jbd2_journal_dirty_metadata(handle, bh);
>>  	if (err)
>> -		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
>> +		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>>  	return err;
>>  }
>
> What about changing the __FUNCTION__ to __func__, while you are at it?

What's wrong with __FUNCTION__?  I thought that was ANSI C?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

