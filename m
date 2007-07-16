Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbXGPQbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbXGPQbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760699AbXGPQbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:31:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759614AbXGPQbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:31:08 -0400
Date: Mon, 16 Jul 2007 09:29:52 -0700
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/10] sysfs: fix error handling in create_files()
Message-ID: <20070716162952.GB30975@suse.de>
References: <20070716134855.GA1858@APFDCB5C> <20070716135230.GC2040@APFDCB5C> <20070716172945.54e07c3c@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716172945.54e07c3c@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 05:29:45PM +0200, Cornelia Huck wrote:
> On Mon, 16 Jul 2007 22:52:30 +0900,
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 
> > Current error handling in create_files() attempts to remove
> > all attributes passed by argument by remove_files(). But it should
> > only remove the attributes that have been successfully added.
> 
> While this is certainly cleaner, a question out of curiousity: Does
> this fix any problem you saw? sysfs_hash_and_remove() used to be safe
> on non-existing attributes...

I agree, the existing code should work just fine, are you finding that
it does not for some reason?

thanks,

greg k-h
