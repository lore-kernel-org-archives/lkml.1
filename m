Return-Path: <linux-kernel-owner+w=401wt.eu-S934793AbXEHIvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934793AbXEHIvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934732AbXEHIvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:51:43 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58718 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934679AbXEHIvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:51:42 -0400
Date: Tue, 8 May 2007 10:50:07 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: why don't top-level menu entries have help info?
In-Reply-To: <20070507202813.GA20680@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.61.0705081044090.17280@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0705071548240.29393@localhost.localdomain>
 <20070507202813.GA20680@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>On Mon, May 07, 2007 at 03:54:13PM -0400, Robert P. J. Day wrote:
>> 
>>   i'd be surprised if this hasn't come up before, but would it be hard
>> to add a facility to Kconfig so that "menu" entries have some help
>> info?

Currently, you have to (needlessy) enter the MD menu for example and
*in there* read the help text of CONFIG_MD, then decide if you want
it or not. I hope my use-menuconfig-objects patches help this issue
a bit ... not only avoiding to enter it, but also making the help
text available in the upper level. Take CONFIG_EMBEDDED, it DTRTs.

I do not think it will be too helpful to have help texts on menu, for
the "important" Kconfig objects (config, choice, menuconfig) should
have it - and they have it.

>>   after i run "make menuconfig" and i'm sitting at the main menu,
>> there's nothing to help me out in understanding what any of those
>> choices might mean.
>> 
>>   i might see "Instrumentation Support" and wonder just what that is,
>> but if i ask for help (which is, as you can see, clearly available
>> at the bottom of the config screen), i get nothing meaningful, just
>> the generic README.
>> 
>>   i think it would be helpful if those entries also supported help
>> info.  just my $0.02.

Jan
-- 
