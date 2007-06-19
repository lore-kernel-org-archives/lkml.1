Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbXFSSvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbXFSSvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762900AbXFSSvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:51:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbXFSSvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:51:36 -0400
Date: Tue, 19 Jun 2007 20:51:25 +0200
From: Karel Zak <kzak@redhat.com>
To: Andries Brouwer <Andries.Brouwer@cwi.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mount-2.12r-ggk.tar.gz
Message-ID: <20070619185125.GU7226@petra.dvoda.cz>
References: <200706191238.l5JCcxg14300@apps.cwi.nl> <20070619141528.GS7226@petra.dvoda.cz> <20070619152818.GA16363@apps.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619152818.GA16363@apps.cwi.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 05:28:18PM +0200, Andries Brouwer wrote:
> > > The above mount makes a feeble attempt to record these flags
> > > in /etc/mtab, but will fail in any nontrivial situation.]
> > 
> >  I don't think that mtab is a good place for this shared subtree
> >  stuff. The mtab needs to die.
> 
> Perhaps. Perhaps not.
> 
> On the one hand I think there is a place for arbitrary user-space info
> about mounted filesystems. With information about who mounted, and at what time.
> What the icon is that should represent this filesystem. What resources are
> associated to this mount, and which program must do the cleanup. Etc.
> Today there is not much user-space info, but there is some.

 See also the "[RFC] obsoleting /etc/mtab" thread:
 http://www.mail-archive.com/util-linux-ng@vger.kernel.org/index.html#00208

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
