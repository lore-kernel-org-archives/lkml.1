Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbZIBWjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbZIBWjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 18:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZIBWjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 18:39:22 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:52772 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbZIBWjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 18:39:21 -0400
Date: Wed, 2 Sep 2009 15:37:39 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fsync: wait for data writeout completion before
 calling ->fsync
Message-ID: <20090902223739.GE7729@mail.oracle.com>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
 <20090902221838.GA5311@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902221838.GA5311@lst.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A9EF40E.009C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 12:18:38AM +0200, Christoph Hellwig wrote:
>  - ocfs2_sync_file:
> 
> 	does it's own data writeback, but no wait.  probably needs the wait.

	The journal force commit will wait in ordered mode.  In
writeback mode we currently allow the usual writeback problem.

Joel

-- 

"There are some experiences in life which should not be demanded
 twice from any man, and one of them is listening to the Brahms Requiem."
        - George Bernard Shaw

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
