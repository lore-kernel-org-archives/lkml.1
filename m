Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbZHaJ0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbZHaJ0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 05:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZHaJ0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 05:26:35 -0400
Received: from smtp.nokia.com ([192.100.122.233]:55315 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZHaJ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 05:26:34 -0400
Message-ID: <4A9B96A7.5040005@gmail.com>
Date: Mon, 31 Aug 2009 12:23:51 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>
CC: Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
Subject: Re: [PATCH 00/18] OMAP: DSS2: Intro
References: <1251462337-12531-1-git-send-email-tomi.valkeinen@nokia.com>
In-Reply-To: <1251462337-12531-1-git-send-email-tomi.valkeinen@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 Aug 2009 09:24:20.0527 (UTC) FILETIME=[D21123F0:01CA2A1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2009 03:25 PM, Tomi Valkeinen wrote:
> This patch set implement new display subsystem driver (DSS2) and omapfb driver
> for OMAP2/3. The patches have been reviewed on linux-omap and linux-fbdev-devel
> mailing lists. The patches can also be found from
> http://gitorious.org/linux-omap-dss2/linux
>
> The patches include DSS documentation patch that includes more instructions for
> module parameters, sysfs files etc.
>
> The patches enable DSS2 for OMAP3430 SDP board. DSS2 is used in various boards,
> for example Nokia N900, Beagle Board and Overo.
>
> I don't currently have any OMAP2 board to test DSS2, but it has worked on OMAP2
> and the possible fixes needed should be minimal.
>
> OMAP1 is not supported, and so the old DSS needs to be used on OMAP1 boards.
>
> DSS2 is partly based on the old omapfb driver by Imre Deak, and Imre has also
> contributed to DSS2 quite a bit. Ville Syrjälä has been contributing to scaling
> and tv-out work. Also some contributions have been made by Hardik Shah, Vaibhav
> Hiremath, and perhaps some others that I have forgotten =).

Tony, Andrew,

how could we merge this code (unless there are requests to change something, which
does not seem to be the case.). It seems like there is no maintainer who could
merge this. Or there is? Would Tomi need to send a direct pull request to Linus,
or this could got via Tony?

We are using DSS2 in Nokia for about a year already. N900 is using this
code, for example. Other (non-Nokia) projects are using DSS2 as well.
The code was public for long time and was sent several times for review.

In any case,

Tested-by: Artem Bityutskiy <artem.bityutskiy@nokia.com>

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
