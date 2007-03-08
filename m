Return-Path: <linux-kernel-owner+w=401wt.eu-S933185AbXCHTef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbXCHTef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXCHTef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:34:35 -0500
Received: from fed1rmmtao103.cox.net ([68.230.241.43]:42551 "EHLO
	fed1rmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbXCHTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:34:31 -0500
X-Greylist: delayed 2689 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 14:34:31 EST
Date: Thu, 8 Mar 2007 11:49:41 -0700
From: Tom Rini <trini@kernel.crashing.org>
To: Andi Kleen <ak@suse.de>
Cc: Dave Jiang <djiang@mvista.com>, linux-kernel@vger.kernel.org,
       sshtylyov@ru.mvista.com
Subject: Re: [PATCH] x86_64 RESTORE_CONTEXT missing '\n'
Message-ID: <20070308184940.GP11626@smtp.west.cox.net>
References: <20070307204516.GA24095@blade.az.mvista.com> <200703081814.53153.ak@suse.de> <45F04B6E.9000703@mvista.com> <200703081937.56167.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703081937.56167.ak@suse.de>
Organization: Embedded Alley Solutions, Inc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 07:37:56PM +0100, Andi Kleen wrote:
> On Thursday 08 March 2007 18:44, Dave Jiang wrote:
> 
> > In spite of kgdb, shouldn't it have that \n anyways in case some other code
> > gets added in the future after the macro? Or are you saying that there should
> > never be any code ever after that macro?
> 
> Sure if there is mainline code added after that macro we add the \n.
> But only if it makes sense to add code there, which it didn't in kgdb.

Was that because with recent enough tools and config options there was
enough annotations so GDB could finally figure out where things had
stopped?  Thanks.

-- 
Tom Rini
