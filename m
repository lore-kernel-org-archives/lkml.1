Return-Path: <linux-kernel-owner+w=401wt.eu-S1763254AbYDXPdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763254AbYDXPdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762962AbYDXPdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:33:31 -0400
Received: from outbound-mail-13.bluehost.com ([69.89.18.113]:52070 "HELO
	outbound-mail-13.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763052AbYDXPd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:33:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] PCI Express ASPM support should default to 'No'
Date: Thu, 24 Apr 2008 08:33:19 -0700
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
References: <alpine.LNX.1.00.0804230024210.14359@dragon.funnycrock.com> <87abjjzo84.fsf@basil.nowhere.org> <1209024126.7479.0.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1209024126.7479.0.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804240833.19614.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 12.108.5.2 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2008 1:02 am Shaohua Li wrote:
> On Thu, 2008-04-24 at 09:49 +0200, Andi Kleen wrote:
> > Shaohua Li <shaohua.li@intel.com> writes:
> > > Ok, I'm fine with the patch. Though by default, the policy is to use
> > > BIOS setting, that is if BIOS disables ASPM, we don't enable it too.
> >
> > Once the feature is considered stable it would be nice to make it
> > default y
> > again. I think any power saving should be on by default (unless
> > serious
> > issues are known), not off.
>
> yes, we could do it in next release.

When we move to 'default y' we should also update the Kconfig text, removing 
the experimental tag and changing the advice.

And yeah, I'd like to save power by default too, but do you think this has 
seen enough test coverage to enable it by default?  Do we know of any 
platforms where ASPM causes problems because the BIOS enabled it and we tried 
to use it?


Thanks,
Jesse
