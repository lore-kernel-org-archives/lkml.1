Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbXFTWGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbXFTWGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXFTWGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:06:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbXFTWGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:06:03 -0400
Date: Thu, 21 Jun 2007 00:05:51 +0200
From: Karel Zak <kzak@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that through other means
Message-ID: <20070620220551.GX7226@petra.dvoda.cz>
References: <467994BD.6000403@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467994BD.6000403@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 01:57:33PM -0700, H. Peter Anvin wrote:
> 
> We could add a field to /proc/mounts to add this information:
> 
> /dev/md6 /export ext3 rw,data=ordered 0 0 /
> /dev/md6 /home/foo ext3 rw,data=ordered 0 0 /users/foo
> /dev/md6 /home/bar ext3 rw,data=ordered 0 0 /users/bar

 I prefer this format. It's compatible with the mount(8) -- the mount
 ignores extra columns.

> ... or, alternatively, add a subfield to the first field (which would
> entail escaping whatever separator we choose):
> 
> /dev/md6 /export ext3 rw,data=ordered 0 0
> /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
> /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0

 We needn't a new separator (':') there already is one (' ').

> I'm personally leaning toward the second option (/dev/md6:/users/foo).
> Although that might confuse current utilities, those utilities are
> *already* liable to get confused by the fact that the line doesn't mean
> what they think it means.

 Many people use "ln -s /proc/mounts /etc/mtab".

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
