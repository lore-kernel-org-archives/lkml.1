Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXJ2Tsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXJ2Tsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbXJ2TrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:47:25 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:60602 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbXJ2TrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:47:22 -0400
Date: Mon, 29 Oct 2007 13:47:20 -0600
From: Andreas Dilger <adilger@sun.com>
To: Mike Waychison <mikew@google.com>
Cc: Chris Mason <chris.mason@oracle.com>, Anton Altaparmakov <aia21@cam.ac.uk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kalpak Shah <Kalpak.Shah@sun.com>
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
Message-ID: <20071029194720.GC3042@webber.adilger.int>
Mail-Followup-To: Mike Waychison <mikew@google.com>,
	Chris Mason <chris.mason@oracle.com>,
	Anton Altaparmakov <aia21@cam.ac.uk>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kalpak Shah <Kalpak.Shah@Sun.COM>
References: <20071026233732.568575496@crlf.corp.google.com> <E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk> <20071029101001.4378a7cf@think.oraclecorp.com> <47263187.5070106@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47263187.5070106@google.com>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 29, 2007  12:16 -0700, Mike Waychison wrote:
> Chris Mason wrote:
>> Reiserfs and Btrfs also use 0 to mean packed.  It would be nice if there
>> was a way to indicate your-data-is-here-but-isn't-alone.  But that's
>> more of a feature for the FIEMAP stuff.
>
> I hadn't heard of FIEMAP, so I went back and read the thread from 
> April/May.  It seems that this is a much better approach than introducing a 
> FIBMAP64.
>
> What ever happened with this proposal?

We made a patch for ext4 that we need to update and push upstream.  I've
just resent the spec we used in a separate email (attached to old thread)
for reference.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

