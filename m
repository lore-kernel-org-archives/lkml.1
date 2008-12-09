Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYLIPuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYLIPuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 10:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYLIPu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 10:50:28 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:50480 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYLIPu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 10:50:28 -0500
Date: Tue, 9 Dec 2008 16:50:25 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bruno.premont@restena.lu>
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Winter <stefan.winter@restena.lu>
Subject: Re: [2.6.27.4-5 stable regressions] Kernel boot early crash with
 low-64k reservation patches
Message-ID: <20081209165025.679fd673@pluto.restena.lu>
In-Reply-To: <20081209153654.GC25679@suse.de>
References: <20081209083440.7569d7a0@pluto.restena.lu>
	<20081209153654.GC25679@suse.de>
Organization: Fondation RESTENA
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008 07:36:54 -0800 Greg KH wrote:
> On Tue, Dec 09, 2008 at 08:34:40AM +0100, Bruno Prémont wrote:
> > Hi,
> > 
> > On a VMWare (ESX 3.5.0 Update 3) guest we get boot failure at the
> > very beginning of boot process. (Boot successful with 2.6.27.4,
> > failing with 2.6.27.x where x > 4 or just adding the 5 patches
> > below to 2.6.27.4)
> > 
> > State of config option
> >   CONFIG_X86_RESERVE_LOW_64K=y
> > or
> >   # CONFIG_X86_RESERVE_LOW_64K not set
> > does not make any difference.
> 
> Does the 2.6.27.8 kernel work better for you, or does it also fail?
> 
> Also, have you tried the 2.6.28-rc releases to see if the problem is
> also there?
> 
> thanks,
> 
> greg k-h

Any stable release after 2.6.27.4 is bad (that is 2.6.27.5,
2.6.27.6, 2.6.27.8 -- 2.6.27.7 has not been tested), they all produce
the same (not verified exact register/stack values) result.

We have not tried any 2.6.28-rc kernels yet.

Bruno
