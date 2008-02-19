Return-Path: <linux-kernel-owner+w=401wt.eu-S1763305AbYBSXaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763305AbYBSXaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbYBSX3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:29:51 -0500
Received: from mail.suse.de ([195.135.220.2]:34853 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713AbYBSX3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:29:50 -0500
Date: Tue, 19 Feb 2008 15:25:56 -0800
From: Greg KH <gregkh@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb/serial/io_ti.c: inconsequent NULL checking
Message-ID: <20080219232556.GB1963@suse.de>
References: <20080219224915.GN31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219224915.GN31955@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 12:49:15AM +0200, Adrian Bunk wrote:
> The Coverity checker spotted the following inconsequent NULL checking 
> introduced by commit d5f5bcd425b771c0b7ff5a650b2ce061ac8bbb87:
> 
> <--  snip  -->

It's not a real problem, that pointer can't go away.

thanks,

greg k-h
