Return-Path: <linux-kernel-owner+w=401wt.eu-S1765313AbXHHKKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765313AbXHHKKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbXHHKJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:09:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:48922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbXHHKJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:09:49 -0400
From: Andi Kleen <ak@suse.de>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Date: Wed, 8 Aug 2007 12:08:00 +0200
User-Agent: KMail/1.9.1
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1185851583.23149.30.camel@caritas-dev.intel.com> <200708071154.23150.ak@suse.de> <1186561082.4430.63.camel@caritas-dev.intel.com>
In-Reply-To: <1186561082.4430.63.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081208.01080.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The needed code changing is minimal. In fact, I can boot 32bit Linux
> kernel on my x86_64 EFI machine. With setup as follow:
>
> 1. Apply the efi-fb.patch
Just for the frame buffer, right?

> 2. make efi fb driver not depend on EFI
> 3. configure kernel as follow:
>    a. CONFIG_EFI is turned off
>    b. CONFIG_FB_EFI is turned on

Hmm, how does the 32bit kernel know where the e820 map is passed then?
With CONFIG_EFI turned off it will just ask the real mode BIOS I think
and I doubt elilo simulates that.

Or did you apply more patches?

-Andi
