Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbYJGX2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbYJGX2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYJGX2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:28:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52936 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbYJGX2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:28:24 -0400
Date: Tue, 7 Oct 2008 17:28:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
Message-ID: <20081007232807.GL25780@parisc-linux.org>
References: <1223416391.8195.22.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223416391.8195.22.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 02:53:11PM -0700, Harvey Harrison wrote:
> In addition, there are some subsystems (scsi) that are looking into some
> differently sized endian helpers (be24) and it may be worthwhile to have
> some agreement whether it is worth making them common infrastructure and
> whether they should present a similar API to the common byteorder/unaligned
> API.

I still think SCSI should have its own accessors, even if they're
just wrappers around the common BE code.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
