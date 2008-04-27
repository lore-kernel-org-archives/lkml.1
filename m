Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbYD0GBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbYD0GBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 02:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYD0GBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 02:01:48 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45543 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYD0GBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 02:01:48 -0400
Date: Sun, 27 Apr 2008 08:02:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
Subject: Re: CONFIG_OPTIMIZE_INLINING
Message-ID: <20080427060218.GA9199@uranus.ravnborg.org>
References: <20080426.215513.141243565.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.215513.141243565.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 09:55:13PM -0700, David Miller wrote:
> 
> Ingo, why the heck is this hiding under arch/x86/ and not in
> lib/Kconfig.debug where it belongs?
> 
>     x86: add optimized inlining
> 
> If there are platforms that can't handle it, we can add a conditional
> to lib/Kconfig.debug, but by default it should be made available
> generically.
> 
> Where did this original patch get posted for review and discussion?

The first version of the patch was this one I think:
http://lkml.org/lkml/2008/3/3/122

	Sam
