Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbXDGAX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbXDGAX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbXDGAX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:23:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40156 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416AbXDGAX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:23:27 -0400
Message-ID: <4616E459.1090409@zytor.com>
Date: Fri, 06 Apr 2007 17:22:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070404183012.429274832@szeredi.hu> <20070406160238.f3178189.akpm@linux-foundation.org> <4616D4D4.6020405@zytor.com> <Pine.LNX.4.61.0704070153180.22181@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704070153180.22181@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 6 2007 16:16, H. Peter Anvin wrote:
>>>> - users can use bind mounts without having to pre-configure them in
>>>> /etc/fstab
>>>>
>> This is by far the biggest concern I see.  I think the security implication of
>> allowing anyone to do bind mounts are poorly understood.
> 
> $ whoami
> miklos
> $ mount --bind / ~/down_under
> 
> later that day:
> # userdel -r miklos
> 
> So both the source (/) and target (~/down_under) directory must be owned 
> by the user before --bind may succeed.
> 
> There may be other implications hpa might want to fill us in.

Consider backups, for example.

	-hpa
