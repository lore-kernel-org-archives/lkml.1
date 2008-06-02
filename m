Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYFBQPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYFBQPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYFBQOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:14:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:15287 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYFBQOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Flp8hTsKitdHQiPgUS5zOKud2Un8pUHcZ7t+O5zXogra4LqzhbH5hgPj0/84aUT8naqn8i6T8k5f2T4KqI3jX1fZONfZADVcshze8ijeHtJNOSG5p/tM23jf8VhwwRYGKB/Ua+MmNaQlicuw0hhEVpGhWhA3whtlJBsbkMCRO7E=
Message-ID: <84144f020806020914w6b86c715s373306abc0f259d4@mail.gmail.com>
Date: Mon, 2 Jun 2008 19:14:40 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: find: WARNING: Hard link count is wrong for /proc/1
Cc: linux-kernel@vger.kernel.org, "Pavel Emelyanov" <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>, "Jan Kara" <jack@suse.cz>
In-Reply-To: <84144f020806020911x4a74b32dj3192055a0320bd64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
	 <19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
	 <84144f020806020911x4a74b32dj3192055a0320bd64@mail.gmail.com>
X-Google-Sender-Auth: 63317a665f9e4809
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 7:11 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Mon, Jun 2, 2008 at 10:00 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index c447e07..10ee4a2 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -2589,6 +2589,9 @@ static struct dentry
>> *proc_pid_instantiate(struct inode *dir,
>>  #ifdef CONFIG_SECURITY
>>        inode->i_nlink += 1;
>>  #endif
>> +#ifdef CONFIG_NET
>
> #if defined(CONFIG_SECURITY) || defined(CONFIG_NET) ?

Oh, forget it. I need to start thinking before posting.
