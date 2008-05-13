Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYEMPbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYEMPbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYEMPbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:31:05 -0400
Received: from sandeen.net ([209.173.210.139]:29364 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbYEMPbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:31:04 -0400
Message-ID: <4829B435.10200@sandeen.net>
Date: Tue, 13 May 2008 10:31:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: David Chinner <dgc@sgi.com>, Georgi Chorbadzhiyski <gf@unixsol.org>,
       cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net, Donald Douwsma <donaldd@sgi.com>,
       xfs@oss.sgi.com
Subject: Re: [Jfs-discussion] Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com> <482951C3.60600@unixsol.org> <20080513090311.GZ155679365@sgi.com> <20080513092156.GA26736@infradead.org> <20080513092851.GA19879@infradead.org>
In-Reply-To: <20080513092851.GA19879@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, May 13, 2008 at 05:21:56AM -0400, Christoph Hellwig wrote:
>> Well, we could refcount the number of active xfs instances and
>> start/stop the global threads based on that.  Not really worth my
>> time IHMO, but if someone comes up with a clean enough patch it should
>> go in.
> 
> Actually doing it in the VFS might be even better.  Add ->init and
> ->exit methods to struct file_system_type and then the filesystems can
> move most of module_init/exit into the new methods.

Hmm I like that idea! :)

-Eric
