Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbYEAQ7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbYEAQ7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbYEAQ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:58:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44656 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYEAQ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:58:56 -0400
Date: Thu, 1 May 2008 10:58:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org
Subject: Re: [RFC][PATCH 2/5] introduce simple_set_mnt_no_get() helper for NFS
Message-ID: <20080501165839.GS14976@parisc-linux.org>
References: <20080429185943.3BA6A050@kernel> <20080429185945.8D7AD196@kernel> <1209504893.8321.2.camel@heimdal.trondhjem.org> <1209520015.27659.20.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209520015.27659.20.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 06:46:55PM -0700, Dave Hansen wrote:
> On Tue, 2008-04-29 at 14:34 -0700, Trond Myklebust wrote:
> > My only concern is the proliferation of 'simple_*' operations: in some
> > cases in libfs.c we explicitly label those as being for in-memory/ramfs
> > filesystems, whereas in other cases (such as this one) the name appears
> > to be used for more generic functions.
> 
> I'm all to happy to give it a different name.  Any suggestions?

would the vfs_* prefix make sense here?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
