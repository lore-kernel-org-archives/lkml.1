Return-Path: <linux-kernel-owner+w=401wt.eu-S1762633AbYBRXWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762633AbYBRXWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760866AbYBRXWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:22:09 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:42945 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762205AbYBRXWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:22:08 -0500
Message-ID: <47BA131A.5080908@tlinx.org>
Date: Mon, 18 Feb 2008 15:22:02 -0800
From: Linda Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
CC: xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: xfsaild causing 30+ wakeups/s on an idle system since 2.6.25-rcX
References: <47B863A9.5070206@gmail.com>
In-Reply-To: <47B863A9.5070206@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not to look excessively dumb, but what's xfsaild?

xfs seems to be sprouting daemons at a more rapid pace
these days...xfsbufd, xfssyncd, xfsdatad, xfslogd, xfs_mru_cache, and
now xfsaild?

Not a complaint if it ups performance, but I do sorta wonder what all
of them are for and why they are needed "now" but not for, say,
kernels before 2.6.18 (arbitrary number picked out of hat).

Like bufd writes out buffers, logd writes/hands the log, datad?  Isn't
the data in buffers? mru_cache? -- isn't that handled by the linux
block layer?  Sorry...just a bit confused by the additions...

Are there any design docs (scribbles?) saying what these do and why
they were added so I can just go read 'em myself?  I'm sure they
were added for good reason...just am curious more than anything.

Thanksd
-lindad

