Return-Path: <linux-kernel-owner+w=401wt.eu-S935639AbXGRArA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935639AbXGRArA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758969AbXGRAqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:46:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758921AbXGRAqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:46:50 -0400
Date: Tue, 17 Jul 2007 17:46:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Paul Moore <paul.moore@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] SELinux Netlabel updates
In-Reply-To: <469D6135.4000301@googlemail.com>
Message-ID: <alpine.LFD.0.999.0707171745180.27353@woody.linux-foundation.org>
References: <Line.LNX.4.64.0707171945430.10858@d.namei>
 <alpine.LFD.0.999.0707171719320.27353@woody.linux-foundation.org>
 <469D6135.4000301@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Michal Piotrowski wrote:
> 
> Once again I tested both patches, build log shows only this

You clearly didn't test them with CONFIG_NETLABEL set to off, or you have 
a buggy compiler.

You had

	int netlbl_enabled(void)
	{
		return 0;
	}

in a header file.

Now think for a moment what happens when that header file gets included 
multiple times from different C files?

		Linus
