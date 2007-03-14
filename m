Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbXCNRHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbXCNRHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXCNRHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:07:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32873 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXCNRHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:07:30 -0400
Date: Wed, 14 Mar 2007 17:07:20 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linuxppc-dev@ozlabs.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] fix ps3fb glue allowing a modular build
Message-ID: <20070314170720.GL4095@ftp.linux.org.uk>
References: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk> <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be> <20070314160258.GK4095@ftp.linux.org.uk> <Pine.LNX.4.62.0703141715570.28462@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0703141715570.28462@pademelon.sonytel.be>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 05:17:45PM +0100, Geert Uytterhoeven wrote:
> 	Hi Al,
> 
> On Wed, 14 Mar 2007, Al Viro wrote:
> > On Wed, Mar 14, 2007 at 10:50:16AM +0100, Geert Uytterhoeven wrote:
> > > On Wed, 14 Mar 2007, Al Viro wrote:
> > > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > 
> > > NAK
> > 
> > Lovely...  Consider that one withdrawn, please.  FWIW, if we leave it bool
> > (and flip_ctl mess alone would make a good reason for that) we probably want
> > to have it depend on FB=y
> 
> What's the advantage of making FB_PS3 depend on FB=y vs. plain FB?
> In both cases it can be enabled if FB=y only, right? Or am I missing something?

Nope.  How can kconfig distinguish that from a boolean option in modular
driver?  bool *can* depend on tristate and be selected when tristate is
set to m.
