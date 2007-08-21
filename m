Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbXHUDym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbXHUDym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 23:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXHUDyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 23:54:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35864 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXHUDyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 23:54:32 -0400
Message-ID: <46CA61DD.4010102@zytor.com>
Date: Mon, 20 Aug 2007 20:54:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1186990219.22431.37.camel@caritas-dev.intel.com>	 <20070815154245.500c572c.akpm@linux-foundation.org>	 <1187250664.15063.0.camel@caritas-dev.intel.com> <46C45B22.5090701@suse.de>	 <1187313920.28497.1.camel@caritas-dev.intel.com>	 <46C5C8C4.4060407@zytor.com>	 <1187580031.27947.67.camel@caritas-dev.intel.com>	 <46C9CB89.7020603@zytor.com> <1187660689.20920.27.camel@caritas-dev.intel.com>
In-Reply-To: <1187660689.20920.27.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> 
> I think the "next" field can be u32 instead of u64. Because the linked
> list of struct setup_data is prepared by bootloader, which can control
> the memory location.
> 

That's making some pretty serious assumptions on future boot loaders and
environments.

> Previously, I think the "zero page" is not external formally, so we can
> ignore the user. But it is used by some bootloaders. So your proposal
> may be better, especially for these bootloaders.
> 
> I think something others need to be done:
> 
> - Increase the version number of standard boot protocol.
> - Add the contents of zero page into standard boot protocol document as
> a optional part for 32-bit entry (and 64-bit entry?).

Probably, yes.

> As for the magic number in zero page, do you think it should be used
> only by 16-bit kernel setup code?

Absolutely not.

	-hpa
