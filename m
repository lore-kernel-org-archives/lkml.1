Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbYK1LQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbYK1LQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYK1LQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:16:37 -0500
Received: from mail2.shareable.org ([80.68.89.115]:41768 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYK1LQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:16:36 -0500
Date: Fri, 28 Nov 2008 11:16:30 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mingo@redhat.com, val.henson@gmail.com, matthew@wil.cx
Subject: Re: [PATCH v3] relatime: Make relatime smarter
Message-ID: <20081128111630.GG6138@shareable.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org> <20081127191547.7c9cf6d2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127191547.7c9cf6d2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > +	relatime_interval=
> > +			[FS] relative atime update frequency, in seconds.
> > +			(default: 1 day: 86400 seconds)
> 
> What about leap seconds  ;)

More generally - is the relatime_interval in "monotonic" seconds, or
in gettimeofday seconds which are changed by clock updates?

-- Jamie
