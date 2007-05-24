Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXEXXMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXEXXMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbXEXXMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:12:09 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47996 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbXEXXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:12:08 -0400
Message-ID: <46561BBE.7030902@zytor.com>
Date: Thu, 24 May 2007 16:11:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524150223.41063046.akpm@linux-foundation.org> <46560E4F.2080009@zytor.com> <20070524224154.GA29337@redhat.com> <465616F3.6090501@zytor.com> <20070524230634.GA30651@redhat.com>
In-Reply-To: <20070524230634.GA30651@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Thu, May 24, 2007 at 03:51:31PM -0700, H. Peter Anvin wrote:
>  > What you're describing is correct for later-level AMD/Cyrix chips,
>  > however, when 3DNow! was first introduced they foolishly squatted on the
>  > Intel-assigned CPUID flags.
> 
> Hmm, the 3dnow spec (doc 21928e) has it in the right place, and I don't see
> anything in the errata docs I have.
> 
> Do you have more info on this?  If its true, I'd like to make x86info
> aware of it.

I don't have exact details, but I have sent off a query to someone I
know that probably *does* know the exact details.

Linux does the right thing, as it will turn off bit 31 if it seems AMD,
Cyrix or Centaur as the vendor ID (VIA still uses the Centaur VID
apparently.)

	-hpa
