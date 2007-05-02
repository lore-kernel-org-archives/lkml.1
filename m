Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbXEBPqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbXEBPqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXEBPqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:46:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38522 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755218AbXEBPqv (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:46:51 -0400
Date: Thu, 3 May 2007 01:46:37 +1000
From: David Chinner <dgc@sgi.com>
To: Gerhard Mack <gmack@innerfire.net>
Cc: "Cabot, Mason B" <mason.b.cabot@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070502154637.GC77450368@melbourne.sgi.com>
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <Pine.LNX.4.64.0705012353100.5330@mtl.rackplans.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705012353100.5330@mtl.rackplans.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 11:54:04PM -0400, Gerhard Mack wrote:
> On Tue, 1 May 2007, Cabot, Mason B wrote:
> 
> > Hello all,
> > 
> > I've been testing the NAS performance of ext3/Openfiler 2.2 against
> > NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> > video workloads. The Windows CIFS client will attempt a poor-man's
> > pre-allocation of the file on the server by sending 1-byte writes at
> > 128K-byte strides, breaking block allocation on ext3 and leading to
> > fragmentation and poor performance. This will happen for many
> > applications (including iTunes) as the CIFS client issues these
> > pre-allocates under the application layer.
> > 
> > I've posted a brief paper on Intel's OSS website
> > (http://softwarecommunity.intel.com/articles/eng/1259.htm). Please give
> > it a read and let me know what you think. In particular, I'd like to
> > arrive at the right place to fix this problem: is it in the filesystem,
> > VFS, or Samba?
> > 
> > thanks,
> > Mason 
> > 
> 
> Just out of curiosity do other filesystems(reiser, xfs) take the same 
> performance hit?

XFS was also tested - it is as fast as the Windows NTFS based
server.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
