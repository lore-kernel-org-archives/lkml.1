Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbXIVWCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbXIVWCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 18:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbXIVWCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 18:02:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:62280 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXIVWCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 18:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=syCkVs0cirmCiqF37N6uKYlwatf3oNNJ4UpUyvzhGtgynWpF5BjGKtZuXV01+3xldYbmnjLTi0tc9B1vzB/9lyxp9NjKIiJvBPRW50w/5pl6PTdjZ68I6Z1v7xuOneD3Kxwpi2hoxXTJUEUlU+prkxoUkFJgx8UlhzVuf6r3xcs=
Message-ID: <9e0cf0bf0709221502u1701cd16vcb31f88896924d6e@mail.gmail.com>
Date: Sun, 23 Sep 2007 00:02:06 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Cc: "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Andrew Morton" <akpm@linux-foundation.org>, nigel@suspend2.net,
       "Pavel Machek" <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Kexec Mailing List" <kexec@lists.infradead.org>
In-Reply-To: <1190342757.21818.75.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
	 <200709211157.28622.nigel@nigel.suspend2.net>
	 <1190341137.21818.52.camel@caritas-dev.intel.com>
	 <200709211225.25874.nigel@nigel.suspend2.net>
	 <1190342757.21818.75.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/07, Huang, Ying <ying.huang@intel.com> wrote:
> This is fairly simple in fact. For example, you can specify the
> bdev/sectors in kernel command line when do kexec load "kexec -l <...>
> --append='...'", then the image writing system can get it through
> "cat /proc/cmdline".

I hope you take into account encrypted swap configuration.
Currently all three suspend implementations support using encrypted
swap in order to suspend/resume.
A configuration which forces the user to remap encryption on the kexec
kernel during suspend is not valid.

Best Regards,
Alon Bar-Lev.
