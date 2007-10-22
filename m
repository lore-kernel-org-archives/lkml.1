Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbXJVQ4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbXJVQ4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXJVQ4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:56:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49680 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbXJVQ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:56:33 -0400
Date: Mon, 22 Oct 2007 09:56:21 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Crispin Cowan <crispin@crispincowan.com>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LSM conversion to static interface
Message-ID: <20071022165621.GC29876@kroah.com>
References: <200710220224.l9M2Og5t020815@sapphire.spiritone.com> <20071022110718.3f781108@the-village.bc.nu> <471CCB77.3040004@crispincowan.com> <20071022175043.0aa65957@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022175043.0aa65957@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 05:50:43PM +0100, Alan Cox wrote:
> 
> For that reason I think keeping LSM is the right thing to do.

Wait, we aren't talking about dropping LSM at all, just the "LSM is a
module" option.  That's it.  And by making LSM not a module, we can then
go on to fix some of the reported speed issues that are present with the
LSM option enabled right now.

thanks,

greg k-h
