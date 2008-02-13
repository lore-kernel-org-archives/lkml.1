Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbYBMJHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbYBMJHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932090AbYBMJFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:05:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60648
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932242AbYBMJFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:05:19 -0500
Date: Wed, 13 Feb 2008 01:05:50 -0800 (PST)
Message-Id: <20080213.010550.211671868.davem@davemloft.net>
To: sam@ravnborg.org
Cc: linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Make LMB code sharable with sparc64.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080213085735.GB8091@uranus.ravnborg.org>
References: <20080213.004120.22092044.davem@davemloft.net>
	<20080213085735.GB8091@uranus.ravnborg.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 13 Feb 2008 09:57:35 +0100

> Review had been easier if the patch was inlined.

Sorry :)

> Can we plase have this changed to use:
> 
>  config SPARC64
> +	select HAVE_LMB
> 
> And then in lib/Kconfig have
> +config HAVE_LMB
> +	bool
> 
> So we avoid creating a new variable each time we introdce LMB support.
> You would need to update powerpc Kconfig too of course.

Sure, I'll rework this in the next day or so to do things
that way.

Thanks for the review.
