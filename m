Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZHTTPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZHTTPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZHTTPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:15:03 -0400
Received: from mga06.intel.com ([134.134.136.21]:34100 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751842AbZHTTPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:15:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,415,1246863600"; 
   d="scan'208";a="441216504"
Message-ID: <4A8DA0B6.3020109@linux.intel.com>
Date: Thu, 20 Aug 2009 12:15:02 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       stable@kernel.org
Subject: Re: [REGRESSION] _end symbol missing from Symbol.map
References: <4A83B680.5000508@suse.de>	<20090819093704.f1620baa.akpm@linux-foundation.org>	<4A8CE63E.9050702@suse.de> <s5hfxbmpx7h.wl%tiwai@suse.de>
In-Reply-To: <s5hfxbmpx7h.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 03:59 AM, Takashi Iwai wrote:
> 
> So, judging from the commit log, simply reverting it seems to have
> some drawback...?
> 

Yes.  I'm starting to think we should have a list of "known relative
symbols" in relocs.c just as we have a list of "known absolute symbols"
already.

	-hpa
