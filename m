Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbXDPAui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbXDPAui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 20:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbXDPAui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 20:50:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbXDPAui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 20:50:38 -0400
Message-ID: <4622C851.2030509@redhat.com>
Date: Sun, 15 Apr 2007 20:50:25 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: "David R. Litwin" <presently42@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
References: <op.tqthonq5ftfxs2@localhost.localdomain>
In-Reply-To: <op.tqthonq5ftfxs2@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David R. Litwin wrote:

>> 4: ZFS has a HUGE capacity. I don't have 30 exobytes, but I might some
>> day....
> 
> ext4 will probably cope with that.  XFS definitely has very high
> limits though I admit I don't know what they are.
> 
> XFS is also a few exobytes.

The fsck for none of these filesystems will be able to deal with
a filesystem that big.  Unless, of course, you have a few weeks
to wait for fsck to complete.

Backup and restore are similar problems.  When part of the filesystem
is lost, you don't want to have to wait for a full restore.

Sounds simple?  Well, the hard part is figuring out exactly which
part of the filesystem you need to restore...

I don't see ZFS, ext4 or XFS addressing these issues.

IMHO chunkfs could provide a much more promising approach.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
