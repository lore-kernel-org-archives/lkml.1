Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbYDXHt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYDXHt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYDXHtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:49:50 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:13454 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYDXHtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:49:50 -0400
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] PCI Express ASPM support should default to 'No'
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LNX.1.00.0804230024210.14359@dragon.funnycrock.com>
	<200804221712.45972.jbarnes@virtuousgeek.org>
	<1208912721.31625.3.camel@sli10-desk.sh.intel.com>
Date: Thu, 24 Apr 2008 09:49:47 +0200
In-Reply-To: <1208912721.31625.3.camel@sli10-desk.sh.intel.com> (Shaohua Li's message of "Wed, 23 Apr 2008 09:05:21 +0800")
Message-ID: <87abjjzo84.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Apr 2008 07:42:57.0631 (UTC) FILETIME=[D0505EF0:01C8A5DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> On Tue, 2008-04-22 at 17:12 -0700, Jesse Barnes wrote:
>> On Tuesday, April 22, 2008 3:28 pm Jesper Juhl wrote:
>> > Running 'make oldconfig' I just noticed that PCIEASPM defaults to
>> > 'y' in Kconfig even though the feature is both experimental and the
>> > help text recommends that if you are unsure you say 'n'.
>> > It seems to me that this really should default to 'n', not 'y' at the
>> > moment.
>> > The following patch makes that change. Please consider applying.
>> 
>> Seem reasonable, Shaohua?  Please cc linux-pci on PCI patches
>> though...
> Ok, I'm fine with the patch. Though by default, the policy is to use
> BIOS setting, that is if BIOS disables ASPM, we don't enable it too.

Once the feature is considered stable it would be nice to make it default y
again. I think any power saving should be on by default (unless serious
issues are known), not off.

-Andi
