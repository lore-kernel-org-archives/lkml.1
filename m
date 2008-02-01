Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbYBAVHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbYBAVHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760637AbYBAVHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:07:06 -0500
Received: from pat.uio.no ([129.240.10.15]:54439 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759997AbYBAVHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:07:01 -0500
Subject: Re: [PATCH 3/3] enhanced NFS ESTALE error handling (v2)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Staubach <staubach@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <47A387D9.1070206@redhat.com>
References: <4790C76F.2050105@redhat.com>  <47A387D9.1070206@redhat.com>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 16:06:57 -0500
Message-Id: <1201900017.11291.43.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: CE60BC538AAAE7C998E7D3793FF8948C9A44410B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 56 total 6636471 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-01 at 15:58 -0500, Peter Staubach wrote:
> Hi.
> 
> The patch enhanced the ESTALE error handling for NFS mounted
> file systems.  It expands the number of places that the NFS
> client checks for ESTALE returns from the server.
> 
> It also enhances the ESTALE handling for directories by
> occasionally retrying revalidation to check to see whether the
> directory becomes valid again.  This sounds odd, but can occur
> when a systems administrator, accidently or unknowingly,
> unexports a file system which is in use.  All active
> non-directory files become permanently inaccessible, but
> directories can be become accessible again after the
> administrator re-exports the file system.  This is a situation
> that users have been complaining about for years and this
> support can help to alleviate their situations.

As far as I can see, this patch can be applied separately from the VFS
fixes. If so, would it make sense for me to take charge of this patch in
the NFS tree, while Andrew queues up the other two VFS changes in -mm?

Cheers
  Trond

