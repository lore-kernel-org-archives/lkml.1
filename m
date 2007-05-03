Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbXECXRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbXECXRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 19:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbXECXRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 19:17:43 -0400
Received: from ns1.suse.de ([195.135.220.2]:47739 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbXECXRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 19:17:42 -0400
Date: Thu, 3 May 2007 16:14:59 -0700
From: Greg KH <gregkh@suse.de>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/8] remove "#if 0" from find_bus function, export it.
Message-ID: <20070503231459.GB13626@suse.de>
References: <20070503213121.GA20067@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503213121.GA20067@zarina>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 01:31:21AM +0400, Anton Vorontsov wrote:
> This function were placed in "#if 0" because nobody was using it.
> We using it now.

Why?  Shouldn't you just export the pointer you need instead?

> See http://lwn.net/Articles/210610/

I don't understand the need for this link, it talks about how the api
changes all the time, something we all know :)

And if you really want it, and you convince me you really need it, can
you change it to be "bus_find" to play nicer in the namespace?

thanks,

greg k-h
