Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbZDHMBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbZDHMBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932378AbZDHLl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:41:58 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33932 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752431AbZDHLl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:41:57 -0400
Date: Wed, 8 Apr 2009 06:41:53 -0500
From: Robin Holt <holt@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Robin Holt <holt@sgi.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.30-rc1 boot failure on ia64 w/ QLA12160.  Bisected.
Message-ID: <20090408114153.GH10768@sgi.com>
References: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain> <20090408042734.GD10768@sgi.com> <1239176024.32073.2.camel@macbook.infradead.org> <1239176190.32073.3.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239176190.32073.3.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 12:36:29AM -0700, David Woodhouse wrote:
> On Wed, 2009-04-08 at 00:33 -0700, David Woodhouse wrote:
> > Does this fix it?
> 
> Brain fade; don't bother with that one. I think it should be
> &fw->data[6] instead.

According to Jeremy, that fixed it.  Just added it to my workarea and
started a build.

Thanks,
Robin
