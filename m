Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbYD2QQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbYD2QQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYD2QQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:16:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbYD2QQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:16:07 -0400
Date: Tue, 29 Apr 2008 18:16:03 +0200
From: Jan Blunck <jblunck@suse.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: bsn.0007@gmail.com, libc-alpha@sourceware.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Ulrich Drepper <drepper@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 0/2] Union Mount: Directory listing in glibc
Message-ID: <20080429161603.GA30780@bolzano.suse.de>
References: <20080429133201.GA9938@localhost.localdomain> <200804291549.m3TFnb3H024733@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804291549.m3TFnb3H024733@agora.fsl.cs.sunysb.edu>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, Erez Zadok wrote:

> Also, I'll reiterate my previous concern that I think you may need to also
> handle "opaque directories".  See the discussion in section 5.1 "Creation
> and deletion of whiteouts", in the original union mounts paper:

Hmm, if kernel is traversing to the next layer in an union and it finds it to
be opaque the kernel knows that this is the "end" of the union. So after
reading that directory it is done.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
