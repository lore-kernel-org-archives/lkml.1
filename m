Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYLIPlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYLIPlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 10:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYLIPlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 10:41:04 -0500
Received: from mx1.suse.de ([195.135.220.2]:55344 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbYLIPlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 10:41:03 -0500
Date: Tue, 9 Dec 2008 07:36:54 -0800
From: Greg KH <gregkh@suse.de>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bruno.premont@restena.lu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Winter <stefan.winter@restena.lu>
Subject: Re: [2.6.27.4-5 stable regressions] Kernel boot early crash with
	low-64k reservation patches
Message-ID: <20081209153654.GC25679@suse.de>
References: <20081209083440.7569d7a0@pluto.restena.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081209083440.7569d7a0@pluto.restena.lu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 08:34:40AM +0100, Bruno Prémont wrote:
> Hi,
> 
> On a VMWare (ESX 3.5.0 Update 3) guest we get boot failure at the very
> beginning of boot process. (Boot successful with 2.6.27.4, failing with
> 2.6.27.x where x > 4 or just adding the 5 patches below to 2.6.27.4)
> 
> State of config option
>   CONFIG_X86_RESERVE_LOW_64K=y
> or
>   # CONFIG_X86_RESERVE_LOW_64K not set
> does not make any difference.

Does the 2.6.27.8 kernel work better for you, or does it also fail?

Also, have you tried the 2.6.28-rc releases to see if the problem is
also there?

thanks,

greg k-h
