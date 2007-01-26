Return-Path: <linux-kernel-owner+w=401wt.eu-S1161187AbXAZTDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161187AbXAZTDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161180AbXAZTDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:03:10 -0500
Received: from terminus.zytor.com ([192.83.249.54]:41179 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161187AbXAZTDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:03:09 -0500
Message-ID: <45BA5053.1070005@zytor.com>
Date: Fri, 26 Jan 2007 11:02:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Tim Bird <tim.bird@am.sony.com>, Andrew Morton <akpm@osdl.org>,
       Paul Mundt <lethal@linux-sh.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init: support preset lpj value as config option
References: <45B7F5E2.4070800@am.sony.com> <20070125021847.GA7609@linux-sh.org> <45B8F5FB.6090704@am.sony.com> <20070126024411.4d4b6c2e.akpm@osdl.org> <45BA4884.4020205@am.sony.com> <20070126184628.GY10108@waste.org>
In-Reply-To: <20070126184628.GY10108@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> 
> The idea was to allow putting something like "%s" in the built-in
> command line and expanding that with the provided command line. This
> allows you to append/prepend/ignore the provided command line as you
> desire.
> 
> This is a fair bit more complicated than what the existing
> implementations of CONFIG_CMDLINE are doing and details like
> early_cmdline handling don't help matters. Haven't yet come up with an
> implementation I'm happy with.
> 

Yes, and it's worth noting that with the edd stuff we actually parse the 
command line from real mode as well.

One way to do it would be to construct the command line in real mode 
code.  It's not really all that hard, but wouldn't work for those that 
jump directly to the PM entrypoint.

	-hpa
