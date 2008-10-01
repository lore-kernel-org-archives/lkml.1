Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYJADUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYJADUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 23:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYJADTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 23:19:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYJADTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 23:19:52 -0400
Date: Tue, 30 Sep 2008 20:19:07 -0700
From: Greg KH <greg@kroah.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: Building two (external) modules from the same sources
Message-ID: <20081001031907.GA19181@kroah.com>
References: <200809290949.35749.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809290949.35749.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 09:49:34AM +0400, Andrey Borzenkov wrote:
> I have here driver that can be built for two different types of
> hardware from basically the same sources (this is port of old Agere
> drivers for Hermes-I/Hermes-II chipsets).

Cool, do you have a link to the code, I'd be glad to add it to
drivers/staging/ if it's not in a fully-mergable state yet to get wider
users for it.

> Build differs only in one define -DHERMES2 and single file with
> different firmware. Unfortunately "if HII" are spread over sources
> which makes splitting of sources rather questionable.
> 
> What is the best way (from kbuild POV) to build two modules - for H-I
> and H-II - from the same set of source files?

Not to create two different modules, but rather have one module that
works for both pieces of hardware, with dynamic checks for the different
portions.

thanks,

greg k-h
