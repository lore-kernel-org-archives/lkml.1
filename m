Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbZFWLGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbZFWLGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbZFWLGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:06:11 -0400
Received: from mga05.intel.com ([192.55.52.89]:1055 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757865AbZFWLGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:06:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,275,1243839600"; 
   d="scan'208";a="701733376"
Message-ID: <4A40B721.7020409@linux.intel.com>
Date: Tue, 23 Jun 2009 13:06:09 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to  disk, mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>  <4A3E7F38.7030300@linux.intel.com>  <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>  <4A3EE668.5090400@jp.fujitsu.com>  <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>  <4A3F55C7.4030909@linux.intel.com>  <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>  <4A3F7A93.5080004@linux.intel.com>  <8db1092f0906220627w61d9f97g88c91f770f732f03@mail.gmail.com>  <4A3F8BF7.6010406@linux.intel.com> <8db1092f0906220755v55699d5cj697b9bdf48978bd9@mail.gmail.com> <4A404EC6.8080902@jp.fujitsu.com> <Pine.LNX.4.64.0906231142540.5287@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906231142540.5287@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Your patch puts an end to all that.  Something for Andi to rush to
> Linus for -rc1 I think - though I won't be in the least surprised if
> Andi decides on something a little different, it's rather surprising
> to have that mcheck_init() call from over there in just the one case.
> 
> Thanks again,
> Hugh


Yes patch looks good. I was just waiting for reports if it really fixes
the problem.

-Andi
