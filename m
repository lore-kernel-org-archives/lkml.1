Return-Path: <linux-kernel-owner+w=401wt.eu-S1161825AbXECKfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161825AbXECKfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161826AbXECKfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:35:34 -0400
Received: from verein.lst.de ([213.95.11.210]:55046 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161825AbXECKfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:35:33 -0400
Date: Thu, 3 May 2007 12:34:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Roland McGrath <roland@redhat.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org, hch@lst.de,
       linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH -utrace] Move utrace into task_struct
Message-ID: <20070503103449.GB6147@lst.de>
References: <20070502113252.GA8017@localhost.sw.ru> <20070502220203.D73D21801A3@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502220203.D73D21801A3@magilla.sf.frob.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 03:02:03PM -0700, Roland McGrath wrote:
> That's just a workaround for an actual bug that I need to fix.
> You wouldn't really want to do it that way.

It's actuall a very nice and needed simplification.  It gets rid
of an object with subtle life time rules, which is always a good
thing.  The utrace code really needs more patches in the style
of Alexey's as this kind of overengineering is what will cause
hard to debug problems over the long run.
