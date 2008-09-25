Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbYIYDA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbYIYDA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 23:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYIYDAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 23:00:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51747 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYIYDAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 23:00:47 -0400
Date: Wed, 24 Sep 2008 19:48:40 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Message-ID: <20080925024840.GA14575@kroah.com>
References: <Y165ES5i.1222268879.9618400.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y165ES5i.1222268879.9618400.pluto@agmk.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 05:07:59PM +0200, Paweł Sikora wrote:
> Hi All,
> 
> with out-of-tree kernel modules we (users and linux distributions)
> have a problem - with every frequent kernel release we need
> to rebuild them all due to vermagic and possible abi changes.
> this leads to lot of useless work (bumping rpm specs releases,
> preparing rpm packages and so on).

"we" are working hard to remove any and all barriers for modules to be
out-of-tree.  See the recent drivers/staging/ announcement, I can now
take pretty much any code that at least builds and works for someone,
and get it into the kernel tree where it can be properly cleaned up and
cared for over time before it moves to the "correct" location within the
kernel.

What kernel modules do you currently use/rely on that are not in the
main kernel tree?  Do you have links to them?  I'd be glad to add them.

thanks,

greg k-h
