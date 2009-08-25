Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZHYHhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZHYHhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZHYHhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:37:09 -0400
Received: from ozlabs.org ([203.10.76.45]:52267 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbZHYHhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:37:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: kernel segv with 2.6.31-rc6 ?
Date: Tue, 25 Aug 2009 17:07:01 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Roland McGrath <roland@redhat.com>, Helge Deller <deller@gmx.de>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4A89CC4D.5040801@gmx.de> <20090818050637.4C3E74730F@magilla.sf.frob.com> <1250640565.15079.3.camel@mulgrave.site>
In-Reply-To: <1250640565.15079.3.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908251707.01610.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 09:39:24 am James Bottomley wrote:
> Even with the duplicate name, though, the module should be perfectly
> loadable.

In a perfect world, yes, but there are places which assume they'll be
unique and I always thought that reasonable.

Front of my mind is /sys/module/<MODNAME/sections/ which has one file
per section.

Let's figure out how it happened tho; I'd rather fail cleanly than break
subtly and horribly later...

Thanks,
Rusty.
