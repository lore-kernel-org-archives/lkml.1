Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZACUvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZACUvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZACUvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:51:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43207 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZACUvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:51:07 -0500
Message-ID: <495FCFA3.4030000@zytor.com>
Date: Sat, 03 Jan 2009 12:50:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Rob Landley <rob@landley.net>,
       Matthieu CASTET <matthieu.castet@parrot.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net> <200901020513.19593.rob@landley.net> <495E3AF8.6000006@parrot.com> <200901031346.01325.rob@landley.net> <20090103201059.GA4875@uranus.ravnborg.org>
In-Reply-To: <20090103201059.GA4875@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> With respect to your three patches the plan is to:
> - add the updated timeconst patch to kbuild-next

If you add this, you take the responsibility for the breakages that will
occur.  The reason his patch is "simpler" is because he removes the
arbitrary-precision arithmetic, and simply hopes that the system
utilities that he uses uses an integer size which happens to be big enough.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

