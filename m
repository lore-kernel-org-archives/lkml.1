Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZHTWFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZHTWFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZHTWFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:05:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51115 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZHTWFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:05:33 -0400
Message-ID: <4A8DC857.7060002@zytor.com>
Date: Thu, 20 Aug 2009 15:04:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
References: <1250276831.3077.17.camel@sbs-t61.sc.intel.com> <20090814192730.GA6431@ldl.fc.hp.com> <1250279799.3077.41.camel@sbs-t61.sc.intel.com> <20090819210251.GD13061@ldl.fc.hp.com> <1250794594.2754.10.camel@sbs-t61.sc.intel.com> <20090820205425.GF13061@ldl.fc.hp.com> <20090820210342.GC29994@basil.fritz.box> <20090820212024.GG13061@ldl.fc.hp.com> <1250803577.2754.30.camel@sbs-t61.sc.intel.com> <4A8DC349.5060508@zytor.com> <20090820215954.GH13061@ldl.fc.hp.com>
In-Reply-To: <20090820215954.GH13061@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 02:59 PM, Alex Chiang wrote:
> 
> Once you go down this path of thinking though, ACPI starts
> looming, and that has other issues associated with it (in my
> mind, mostly around the cleanliness of implementation as ACPI
> starts poking its fingers everywhere).
> 

Seems more like DMI than ACPI to me, but this kind of stuff is already
creeping into everything no matter what.

*However* the whole point of this is to not muck with data structures
that the kernel actually cares about in any way, and have a separate
field which is only for human consumption.

	-hpa
