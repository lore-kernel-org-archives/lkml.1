Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbYCXIzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbYCXIzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 04:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYCXIy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 04:54:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYCXIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 04:54:56 -0400
Date: Mon, 24 Mar 2008 04:54:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
       dhowells@redhat.com
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
Message-ID: <20080324085442.GB4845@infradead.org>
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk> <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu> <20080320214319.GS10722@ZenIV.linux.org.uk> <1206348614.2961.21.camel@ram.us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206348614.2961.21.camel@ram.us.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 01:50:14AM -0700, Ram Pai wrote:
> I think that ->umount_begin also acts a hook for providing pre-umount
> event notification to userspace from filesystems; something that is
> required by DMAPI interface.

No such thing like dmapi near mainline, and we ever want user-space
assiseted HDM in mainline we'd do it in VFS.

FYI: SGI out of tree dmapi doesn't make use of ->unmount_begin either.

