Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXDGACL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXDGACL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbXDGACK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:02:10 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:51000 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546AbXDGACH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:02:07 -0400
Date: Sat, 7 Apr 2007 01:55:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] unprivileged mount syscall
In-Reply-To: <4616D4D4.6020405@zytor.com>
Message-ID: <Pine.LNX.4.61.0704070153180.22181@yvahk01.tjqt.qr>
References: <20070404183012.429274832@szeredi.hu>
 <20070406160238.f3178189.akpm@linux-foundation.org> <4616D4D4.6020405@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 6 2007 16:16, H. Peter Anvin wrote:
>> > 
>> > - users can use bind mounts without having to pre-configure them in
>> > /etc/fstab
>> > 
>
> This is by far the biggest concern I see.  I think the security implication of
> allowing anyone to do bind mounts are poorly understood.

$ whoami
miklos
$ mount --bind / ~/down_under

later that day:
# userdel -r miklos

So both the source (/) and target (~/down_under) directory must be owned 
by the user before --bind may succeed.

There may be other implications hpa might want to fill us in.

Regards,
Jan
-- 
