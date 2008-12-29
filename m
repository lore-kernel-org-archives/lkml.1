Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYL2UPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYL2UPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYL2UOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:14:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbYL2UOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:14:50 -0500
Date: Mon, 29 Dec 2008 12:14:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] exofs: mkexofs
Message-Id: <20081229121423.efde9d06.akpm@linux-foundation.org>
In-Reply-To: <4947CA5C.50104@panasas.com>
References: <4947BFAA.4030208@panasas.com>
	<4947CA5C.50104@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 17:33:48 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> We need a mechanism to prepare the file system (mkfs).
> I chose to implement that by means of a couple of
> mount-options. Because there is no user-mode API for committing
> OSD commands. And also, all this stuff is highly internal to
> the file system itself.
> 
> - Added two mount options mkfs=0/1,format=capacity_in_meg, so mkfs/format
>   can be executed by kernel code just before mount. An mkexofs utility
>   can now be implemented by means of a script that mounts and unmount the
>   file system with proper options.

Doing mkfs in-kernel is unusual.  I don't think the above description
sufficiently helps the uninitiated understand why mkfs cannot be done
in userspace as usual.  Please flesh it out a bit.

What are the dependencies for this filesystem code?  I assume that it
depends on various block- and scsi-level patches?  Which ones, and
what is their status, and is this code even compileable without them?

Thanks.
