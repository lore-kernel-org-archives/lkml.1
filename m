Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYLBLLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYLBLLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 06:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbYLBLKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 06:10:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53158 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbYLBLKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 06:10:47 -0500
Date: Tue, 2 Dec 2008 12:10:25 +0100
From: Karel Zak <kzak@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jamie Lokier <jamie@shareable.org>, Matthew Garrett <mjg@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v4] relatime: Make relatime smarter
Message-ID: <20081202111025.GI2956@nb.net.home>
References: <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org> <20081127170615.GB14991@infradead.org> <20081127175813.GA24354@srcf.ucam.org> <20081128111809.GH6138@shareable.org> <20081128134055.GQ25548@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128134055.GQ25548@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 06:40:55AM -0700, Matthew Wilcox wrote:
> On Fri, Nov 28, 2008 at 11:18:09AM +0000, Jamie Lokier wrote:
> > Matthew Garrett wrote:
> > > The time between atime updates can be configured at boot
> > > with the relatime_interval kernel argument, or at runtime through a sysctl.
> > 
> > Shouldn't it be a per-mount value, with defaults coming from the sysctl?
> 
> Perhaps a more sensible question would be "Why make it configurable at

 this is GNOME-mentality :-)

> all?"  What's wrong with hardcoding 24 hours?  Or, to put it another
> way, who wants to change it from 24 hours, and why?

 Why do you think that 24 hours is the right default value? Do you
 have any logical argument for this setting?

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
