Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbYCLE3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbYCLE3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 00:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYCLE3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 00:29:06 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45121 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbYCLE3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 00:29:05 -0400
Date: Wed, 12 Mar 2008 09:58:58 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Ulrich Drepper <drepper@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [RFC] Union mount readdir support in glibc
Message-ID: <20080312042858.GB16709@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20080311055527.GA7256@in.ibm.com> <20080311080929.B076D26F991@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311080929.B076D26F991@magilla.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 01:09:29AM -0700, Roland McGrath wrote:
> 
> This really is the kernel filesystem's problem.  It just doesn't make sense
> to expect userland to implement half of your directory semantics for you.

I agree that we are asking glibc to handle part of the union mount
semantics in readdir. But we have tried handling directory listing of
union entirely inside the kernel, but the results haven't been so good.
(http://lkml.org/lkml/2007/12/5/147). Recently Al Viro suggested that we
do this in the userland and he felt that is the only sane way of doing this.
Infact I had mentioned about this approach to Ulrich briefly during
FOSS.IN and he sounded positive to the idea of maintaining a dirent
cache for duplicate elimination as long as it doesn't slowdown normal
users.

Regards,
Bharata.
