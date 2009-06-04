Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbZFDGM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbZFDGM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbZFDGMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 02:12:43 -0400
Received: from smtp.nokia.com ([192.100.122.233]:51845 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbZFDGMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 02:12:41 -0400
Message-ID: <4A276573.5000900@nokia.com>
Date: Thu, 04 Jun 2009 09:10:59 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603223005.GA9050@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20090603223005.GA9050@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Jun 2009 06:11:00.0547 (UTC) FILETIME=[3B96A930:01C9E4DB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Jan Kara wrote:
>   Hi,
> 
>> 2. Make FAT and EXT2 file systems use the above mechanism to optionally
>>    notify user space about errors. Implemented as 'notify' mount option
>>    (PATCH 3,4).
>>    FAT error reporting facilities had to be re-factored (PATCH 2) in 
>>    order to simplify sending error notifications.
>   One question: Why would not a filesystem / admin want the notification
> to be sent? Or in other words what's the point of the mount option?

I agree on this. I guess we should instead implement a VFS helper
like 'send_error_notification(sb, error_type)'. Then we can teach
certain FSes to utilize it. We are particularly interested in FAT,
actually.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
