Return-Path: <linux-kernel-owner+w=401wt.eu-S965797AbXIJWvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965797AbXIJWvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965181AbXIJWvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:51:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45692 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965177AbXIJWvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:51:46 -0400
Message-ID: <46E5CA4D.3060106@zytor.com>
Date: Mon, 10 Sep 2007 15:50:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [RFC] kbuild - introduce vdir to make life easier for x86_64
References: <20070910191138.GA31541@uranus.ravnborg.org> <200709110040.41605.ak@suse.de>
In-Reply-To: <200709110040.41605.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The below are the minimal clean-up - a bit more could be done.
>>
>> Comments?
> 
> Looks good in principle. My only suggestion would be to name it something
> differently than vdir. I know that's what GNU make calls it, but it's still
> pretty cryptic. How about just fallback-dir ? 
> 
> Also what would be nice (I don't know if it's doable in make) would
> be a separate variable (e.g. other-obj-... := ) that contains the fallback
> names and that is double checked against the fallback directory. That
> would document it clearly what's going on. Failing that stuffing 
> them into a comment would be good at least.
> 

<nitpick>

Actually make calls it VPATH, not vdir.

	-hpa
