Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab0AOCJH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 21:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150Ab0AOCJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 21:09:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0AOCJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 21:09:05 -0500
Message-ID: <4B4FCC33.2010100@zytor.com>
Date: Thu, 14 Jan 2010 18:00:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>, Mark Hounschell <markh@compro.net>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alain Knaff <alain@knaff.lu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [patch 2/4] x86: Do not use hpet MSI as clockevent broadcast
 device
References: <20100115013957.027452000@intel.com> <20100115014209.992004000@intel.com>
In-Reply-To: <20100115014209.992004000@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 05:39 PM, Venkatesh Pallipadi wrote:
> Current kernel uses hpet MSI interrupts as both percpu clockevent device
> and also as clockevent broadcast device in place of IRQ0 timer.
> There seems to be issues with HPET MSI usage on some platforms. So,
> restrict it to be only used as a percpu clockevent device.

Any ideas of which platforms?  It would help avoiding "cargo cult
programming" in the future.

Other than that, I presume this is a .33 patch?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

