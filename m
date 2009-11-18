Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbZKRNvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbZKRNvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbZKRNvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:51:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736AbZKRNvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:51:39 -0500
Message-ID: <4B03FB99.6070705@gmail.com>
Date: Wed, 18 Nov 2009 14:50:17 +0100
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: reiserfs-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: reiser4 for 2.6.33?
References: <alpine.DEB.2.01.0911171420480.27639@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0911171420480.27639@bogon.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I told already for reiser4 inclusion we need the following:

(a) plugin design document;
(b) full description of what is going on in respond to memory
    pressure notifications;

The (a) is not yet ready and I don't have a time to explain
personally to everyone why the plugin stuff is not crappy. It will
be posted in a magazine with proper background, because all
Namesys projects traditionally have academic sources. So wait...

Actually there is no hurry. Taking into account common situation
with file systems, I am not afraid that reiser4 will get obsolete.

Thanks,
Edward.

Christian Kujau wrote:
> It's autumn[0] already and even with 2.6.32 not quite ready yet, let me 
> be the one asking the inevitable question:
>  What are the plans for reiser4 being included in 2.6.33? The 
> diffstat for the 2.6.31 patch looks rather promising, at least to me:
>
> $ diffstat reiser4-for-2.6.31.patch | grep -v fs/reiser4
>  Documentation/Changes                         |   12 
>  Documentation/filesystems/reiser4.txt         |   75 
>  fs/Kconfig                                    |    1 
>  fs/Makefile                                   |    1 
>  fs/fs-writeback.c                             |    5 
>  include/linux/fs.h                            |    3 
>  include/linux/mm.h                            |    1 
>  mm/filemap.c                                  |    3 
>  mm/page-writeback.c                           |   26 
>  170 files changed, 77581 insertions(+), 1 deletion(-)
>
> Or maybe it can find a place in -staging if there are still strong 
> objections against a general inclusion?
>
> Thanks,
> Christian.
>
> [0] http://marc.info/?l=reiserfs-devel&m=124904274311847&w=2
>   

