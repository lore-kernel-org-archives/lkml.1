Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYDHUwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYDHUwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYDHUwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:52:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43204 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751536AbYDHUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:52:31 -0400
Message-ID: <47FBDB0D.1010202@sgi.com>
Date: Tue, 08 Apr 2008 13:52:29 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpumask: add show cpu map functions v2
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>	 <20080408184302.113424000@polaris-admin.engr.sgi.com> <36ca99e90804081232iff9b19fp41e76c04cf140446@mail.gmail.com>
In-Reply-To: <36ca99e90804081232iff9b19fp41e76c04cf140446@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>>   * Add cpu_sysdev_class functions to display the following maps
>>     with cpulist_scnprintf().
>>
> Could we add a cpumap_scnprintf() attribute too, just for consistency?
> 
> Bert

Sure, I could add it.  But by not having it, the user is forced to
actually read libbitmask(3) to see a different way of parsing the
output, perhaps weaning them off of cpumask_scnprintf()... ;-)

Do you mind if I add them as:

	/sys/devices/system/cpu/online_map
	/sys/devices/system/cpu/possible_map
	/sys/devices/system/cpu/present_map
	/sys/devices/system/cpu/system_map

Thanks,
Mike
