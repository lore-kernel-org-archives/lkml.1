Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbYK1NlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbYK1NlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYK1NlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:41:13 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:59970 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYK1NlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:41:12 -0500
Date: Fri, 28 Nov 2008 06:40:55 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Jamie Lokier <jamie@shareable.org>
Cc: Matthew Garrett <mjg@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v4] relatime: Make relatime smarter
Message-ID: <20081128134055.GQ25548@parisc-linux.org>
References: <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org> <20081127170615.GB14991@infradead.org> <20081127175813.GA24354@srcf.ucam.org> <20081128111809.GH6138@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128111809.GH6138@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 11:18:09AM +0000, Jamie Lokier wrote:
> Matthew Garrett wrote:
> > The time between atime updates can be configured at boot
> > with the relatime_interval kernel argument, or at runtime through a sysctl.
> 
> Shouldn't it be a per-mount value, with defaults coming from the sysctl?

Perhaps a more sensible question would be "Why make it configurable at
all?"  What's wrong with hardcoding 24 hours?  Or, to put it another
way, who wants to change it from 24 hours, and why?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
