Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbXIZQ6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbXIZQ6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759257AbXIZQ6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:58:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39515 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512AbXIZQ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:58:17 -0400
Message-ID: <46FA8F96.9060208@zytor.com>
Date: Wed, 26 Sep 2007 09:57:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Joerg Pommnitz <pommnitz@yahoo.com>, cebbert@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.23-pre Was: Problems with 2.6.23-rc6 on AMD
 Geode LX800
References: <637040.99806.qm@web51411.mail.re2.yahoo.com> <46FA6858.5060908@zytor.com> <20070926154106.GG7582@cosmic.amd.com>
In-Reply-To: <20070926154106.GG7582@cosmic.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:
> 
> As background, I'm using syslinux 3.36 as my loader here - I've used this
> exact same version for a very long time, so I don't blame it in the least.
> Something is getting confused in the early kernel, and whatever that
> something is, a still unknown change in a newer version of the BIOS
> fixed it.  The search goes on.
> 

OK, we should put printf's in arch/i386/boot/memory.c and see what
actually gets read out from the BIOS.  This could either be a BIOS
problem or a bug in memory.c (or a bug elsewhere in the code that the
change in memory.c triggers, but that seems less likely.)

	-hpa

P.S. Are you guys in the Bay Area by any chance?
