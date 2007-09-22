Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbXIVT4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbXIVT4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 15:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXIVT4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 15:56:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbXIVT4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 15:56:36 -0400
Message-ID: <46F5735C.5040803@zytor.com>
Date: Sat, 22 Sep 2007 12:56:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v3 1/2] i386/x86_64 boot: setup data
References: <1190192306.12429.76.camel@caritas-dev.intel.com> <46F53848.3030100@goop.org>
In-Reply-To: <46F53848.3030100@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Do you actually need a linked list of data?  This is similar to the
> changes to bzImage to support booting bzImage a paravirt environment,
> but I just proposed a pointer to a single info structure, along with a
> field to identify the boot environment (ie, native/lguest/xen etc).  It
> would be easy to extend this to handle EFI as just another boot
> environment, and you could hang a list of structures off the pointer.
> 

*He* doesn't, but *we* do.  We have already run into at least one case
where the existing structure is insufficient (EDD overhaul), and so we
need to do something extensible.

	-hpa
