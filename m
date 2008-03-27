Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbYC0NqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbYC0NqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbYC0Npz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:45:55 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16895 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbYC0Npy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:45:54 -0400
Message-ID: <47EBA45E.5020905@nokia.com>
Date: Thu, 27 Mar 2008 15:42:54 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 20/26] UBIFS: add VFS operations
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>	<1206629746-4298-21-git-send-email-Artem.Bityutskiy@nokia.com> <87bq50jnk7.fsf@basil.nowhere.org>
In-Reply-To: <87bq50jnk7.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Mar 2008 13:45:35.0196 (UTC) FILETIME=[D54451C0:01C89010]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> +		inode->i_gid = current->fsgid;
>> +	inode->i_mode = mode;
>> +	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
> 
> Any specific reason you didn't implement sub second time stamp support?
> There is really no good excuse to not do that on a new file system.

No reason, just thought this should be enough. Will be fixed, thank you.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
