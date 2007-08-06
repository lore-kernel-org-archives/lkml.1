Return-Path: <linux-kernel-owner+w=401wt.eu-S1761904AbXHFQli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761904AbXHFQli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbXHFQl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:41:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbXHFQl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:41:29 -0400
Message-ID: <46B74F08.1050909@zytor.com>
Date: Mon, 06 Aug 2007 09:40:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jeff Chua <jeff.chua.linux@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>
Subject: Re: Linux 2.6.23-rc2
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com> <200708051847.12046.rjw@sisk.pl> <b6a2187b0708051736u74879b9cp9e638364a5b1628e@mail.gmail.com> <200708061326.25888.rjw@sisk.pl>
In-Reply-To: <200708061326.25888.rjw@sisk.pl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 6 August 2007 02:36, Jeff Chua wrote:
>> On 8/6/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>>> What does 's2ram -i' say about your machine?
>> This machine can be identified by:
>>     sys_vendor   = "LENOVO"
>>     sys_product  = "1702E7A"
>>     sys_version  = "ThinkPad X60s"
>>     bios_version = "7BETD0WW (2.11 )"
> 
> This means it's not in the whitelist, AFAICS.
> 
> Similar machines are known to work with "--acpi_sleep=3" or with
> "--acpi_sleep=1 --vbe_mode".
> 

I'm not all that familiar with s2ram.  Any feel for why the behaviour
would have changed from the old setup code at all?  Since the setup code
isn't entered on resume from STR (unlike resume from STD), as far as I
know, there can only be "some little bit of state" hanging around.

If not then perhaps we should try to get a dump of the real-mode state
area for both kernels (which would need a patch, unfortunately.)

	-hpa
