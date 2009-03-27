Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbZC0Uzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbZC0Uzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbZC0UzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:55:21 -0400
Received: from [213.79.90.228] ([213.79.90.228]:58739 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753197AbZC0UzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:55:19 -0400
Date: Fri, 27 Mar 2009 23:55:13 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: cbou@mail.ru,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Using POWER or APM for battery handling
Message-ID: <20090327205513.GA32692@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090327202406.60885d4a.kristoffer.ericson@gmail.com> <20090327192947.GA13609@oksana.dev.rtsoft.ru> <20090327214106.dbf36adf.kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090327214106.dbf36adf.kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 09:41:06PM +0100, Kristoffer Ericson wrote:
[...]
> > The driver is already there:
> > drivers/power/apm_power.c
> > 
> > So all you need is Jornada driver for the power supply class,
> > and then apm_power.c will work for your battery driver.
> > 
> > Feel free to ask if there is anything still not clear.
> 
> Great!
> 
> I think I understand, but should I create this driver
> inside /drivers/power or inside the mach folder (in this case arch/arm/mach-sa1100)?

I would prefer drivers/power/.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
