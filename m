Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYCaUxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYCaUxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYCaUxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:53:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:55608 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbYCaUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:53:38 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [ANNOUNCE] Btrfs v0.13
Date: Mon, 31 Mar 2008 16:52:16 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
References: <200802211609.50563.chris.mason@oracle.com> <20080331202633.GA341@ldl.fc.hp.com>
In-Reply-To: <20080331202633.GA341@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803311652.17234.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008, Alex Chiang wrote:
> * Chris Mason <chris.mason@oracle.com>:
> > Hello everyone,
> >
> > Btrfs v0.13 is now available for download from:
>
> Hi Chris,
>
> Following are two patches that allow btrfs-progs to build on
> ia64, and prevent a SEGV when trying to do a mkfs.btrfs.
>
> I've gotten as far as successfully creating a btrfs filesystem
> (at least that's what btrfsck tells me), but haven't been able to
> mount it yet, probably because of the sector size issue.
>

Great, thanks I'll take these two.  The kernel side needs the same hash.c fix, 
but I've already got that change made locally.

-chris

