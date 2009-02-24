Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbZBXLwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbZBXLwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 06:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZBXLwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 06:52:23 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49835 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZBXLwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 06:52:23 -0500
To: tomas@slax.org
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <49A3AC14.2050107@slax.org> (message from Tomas M on Tue, 24 Feb
	2009 09:13:08 +0100)
Subject: Re: New filesystem for Linux kernel
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org>
Message-Id: <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Feb 2009 12:52:15 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Tomas M wrote:
> An overview of aufs2 has been submitted to this list.
> I noticed zero response at all. Nobody cares?
> 
> I suggest to remove unionfs from Andrew's -mm tree and replace it by aufs2!

Perhaps you should ask Andrew?

> Tell me why this should not happen...

I think the biggest problem is too many features.

   > git diff master...aufs2 | diffstat
    ...
    73 files changed, 23527 insertions(+), 7 deletions(-)
                      ^^^^^^
This is an unreviewable amount of code, it would make AUFS one of the
biggest filesystems on linux.

The first step would be to separate out the very core functionality,
which should be a couple thousands of lines max.  And when that has
been accepted and stabilised, then you can start adding fancy
features.

Miklos
