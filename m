Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbYF0SzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbYF0SzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYF0SzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:55:06 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:42090 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbYF0SzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:55:05 -0400
To: Joerg Roedel <joro@8bytes.org>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Adrian Bunk <bunk@kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
From: Andi Kleen <andi@firstfloor.org>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-2-git-send-email-joerg.roedel@amd.com>
	<20080627142558.GG18644@cs181140183.pp.htv.fi>
	<878wwrq6im.fsf@basil.nowhere.org> <20080627163945.GA26130@il.ibm.com>
	<20080627165430.GD10197@8bytes.org>
Date: Fri, 27 Jun 2008 20:54:59 +0200
In-Reply-To: <20080627165430.GD10197@8bytes.org> (Joerg Roedel's message of "Fri, 27 Jun 2008 18:54:30 +0200")
Message-ID: <87zlp6pv24.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Jun 2008 18:47:40.0257 (UTC) FILETIME=[46A62510:01C8D886]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> On Fri, Jun 27, 2008 at 12:39:45PM -0400, Muli Ben-Yehuda wrote:
>> On Fri, Jun 27, 2008 at 04:47:29PM +0200, Andi Kleen wrote:
>> 
>> > Also it should ideally describe that there is a trade off between
>> > reliability and performance with IOMMU enabled.
>> 
>> I agree that there's a performance tradeoff with current generation
>> hardware and ingerfaces, but it wouldn't be fair to single out a
>> single IOMMU implementation ;=)
>
> True. At least for the case without device isolation I have some
> optimizations in mind which will minimize the performance tradeoff. I
> hope to have them ready for 2.6.28 :)

Not sure that would be very useful. Outside of virtualization device
isolation is the main feature of an IOMMU on a native kernel.

-Andi
