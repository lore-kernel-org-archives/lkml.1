Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYJ1NYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYJ1NYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 09:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYJ1NYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 09:24:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:45029 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752163AbYJ1NYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 09:24:09 -0400
X-Authenticated: #3800222
X-Provags-ID: V01U2FsdGVkX1+znQMymCCz/ReiBTTtmiHfKJBjxqd1pM2VfvWDo5
	v+pmF/rGvdHJPr
Message-ID: <49071272.8050700@gmx.de>
Date: Tue, 28 Oct 2008 14:24:02 +0100
From: Joerg Albert <jal2@gmx.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>, Greg KH <greg@kroah.com>
CC: "otus-devel@lists.madwifi-project.org" 
	<otus-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [otus-devel] Release of Atheros 802.11n USB Linux driver
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com>	<20081022065045.GA2400@kroah.com> <20081023062655.GA8039@kroah.com>	<20081023111103.GB5979@tesla> <43e72e890810271635i5b6dd6e4ua06b48e624991435@mail.gmail.com>
In-Reply-To: <43e72e890810271635i5b6dd6e4ua06b48e624991435@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2008 12:35 AM, Luis R. Rodriguez wrote:

> This is now fixed on the master branch, also the branch "for-upstream"
> does a lot of cleanup I thought you may like before stuffing it into
> staging like removing all KERNEL_VERSION checks, all wireless
> extensions checks, some compile warnings, removal of compat, dos2unix,
> use utf-8, etc. Unfortunately this still requires a specific version
> of wpa_supplicant but it seems it works. Not sure what bars you have
> for staging at this point.

I was a bit disappointed to find binary-only firmware inside the 
driver (HalPlus/OTUS_FB50/{hpfwbu,hpfwuinit}.c which is downloaded 
into the device during startup (initially thought this to be a 
complete OpenSource driver :-(

Unless the attitude towards binary chunks inside the Linux kernel 
have changed, I guess these should be moved into userspace using the 
firmware_class driver to access it.

/Joerg
