Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZGLODh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZGLODh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 10:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZGLOD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 10:03:26 -0400
Received: from smtp.nokia.com ([192.100.105.134]:24307 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZGLODZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 10:03:25 -0400
Message-ID: <4A59ECDE.8070809@gmail.com>
Date: Sun, 12 Jul 2009 17:02:06 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v3 04/18] EXOFS: do not manipulate s_dirt directly
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain> <20090709084849.12122.23929.sendpatchset@localhost.localdomain> <4A59B2AB.9010900@panasas.com>
In-Reply-To: <4A59B2AB.9010900@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Jul 2009 14:02:10.0488 (UTC) FILETIME=[597BD380:01CA02F9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 07/09/2009 11:48 AM, Artem Bityutskiy wrote:
>> ... use new VFS helpers instead.
>>
>> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>> Acked-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> Hi Artem.
> 
> Linus has pulled the exofs tree for 2.6.31-rc3 if you sync
> with it you'll find one more simple call site for is_sb_dirty(sb).
> (See below)

Ok, thanks a lot for letting know.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
