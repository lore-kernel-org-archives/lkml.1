Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZCJO4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZCJO4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbZCJO4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:56:03 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46621 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZCJO4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:56:01 -0400
Date: Tue, 10 Mar 2009 08:55:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 2/2] fs: introduce mnt_clone_write
Message-ID: <20090310145558.GY25995@parisc-linux.org>
References: <20090310143718.GB15977@wotan.suse.de> <20090310143801.GC15977@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310143801.GC15977@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 03:38:01PM +0100, Nick Piggin wrote:
> +EXPORT_SYMBOL_GPL(mnt_clone_write);
> +EXPORT_SYMBOL_GPL(mnt_want_write_file);

You don't add any users of these functions in this patch ... is there a
good reason to export them?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
