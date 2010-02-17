Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0BQW1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:27:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44029 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab0BQW1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:27:10 -0500
Message-ID: <4B7C6D0C.6020801@zytor.com>
Date: Wed, 17 Feb 2010 14:26:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
CC: Nick Bowler <nbowler@elliptictech.com>, david@lang.hm,
       Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       Neil Brown <neilb@suse.de>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
References: <201002140251.59668.volkerarmin@googlemail.com> <201002171927.07051.volkerarmin@googlemail.com> <20100217183703.GA15446@emergent.ellipticsemi.com> <201002171946.09884.volkerarmin@googlemail.com>
In-Reply-To: <201002171946.09884.volkerarmin@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 10:46 AM, Volker Armin Hemmann wrote:
> 
> well at the moment it takes less than two seconds until init takes over.
> 
> Adding .5 seconds is a lot. And loading the initrd and changing root isn't 
> free either, true?
> 
> I remember well all the noise in the past about making linux booting faster. 
> So why slow it down with an initrd - especially if you can do without?
> 

Note that an extremely lightweight initramfs can quite possibly be
faster than doing it in the kernel, just because userspace is so much
less constrained.  I was hoping klibc would catch on for this stuff, but
it hasn't as much as I'd like.

	-hpa
