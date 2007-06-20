Return-Path: <linux-kernel-owner+w=401wt.eu-S1761762AbXFTFBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762AbXFTFBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 01:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbXFTFBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 01:01:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbXFTFBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 01:01:33 -0400
Message-ID: <4678B46F.7070506@zytor.com>
Date: Tue, 19 Jun 2007 22:00:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Bryan Henderson <hbryan@us.ibm.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       akpm@linux-foundation.org, alan <alan@clueserver.org>,
       Chris Snook <csnook@redhat.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <OF35839FC7.229AE944-ON882572FF.007F2DF8-882572FF.00819E1C@us.ibm.com> <1182299263.6504.8.camel@heimdal.trondhjem.org>
In-Reply-To: <1182299263.6504.8.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
>>
>> I assume NetApp flags the directory specially so that a POSIX directory 
>> read doesn't get it.  I've seen that done elsewhere.
> 
> No. The directory is quite visible with a standard 'ls -a'. Instead,
> they simply mark it as a separate volume/filesystem: i.e. the fsid
> differs when you call stat(). The whole thing ends up acting rather like
> our bind mounts.
> It means that you avoid all those nasty user issues where people try to
> hard link to/from .snapshot directories, rename files across snapshot
> boundaries, etc.
> 

Last I used a Netapp, it was configurable, I believe; I seem to also
vaguely remember that one could configure it so that it only was
accessible as part of a mount string rather than as part of an
already-mounted filesystem.  Of course, this was a long time ago.

	-hpa
