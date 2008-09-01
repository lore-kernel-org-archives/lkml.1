Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbYIAXB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbYIAXB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYIAXBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:01:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44370 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYIAXBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:01:21 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Misc fixes for 2.6.27
From: Andi Kleen <andi@firstfloor.org>
References: <1220300084.2982.139.camel@pmac.infradead.org>
	<87wshvwl8v.fsf@basil.nowhere.org>
	<20080901153517.2f8b1ef8@infradead.org>
Date: Tue, 02 Sep 2008 01:01:19 +0200
In-Reply-To: <20080901153517.2f8b1ef8@infradead.org> (Arjan van de Ven's message of "Mon, 1 Sep 2008 15:35:17 -0700")
Message-ID: <87sksjwjwg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Tue, 02 Sep 2008 00:32:16 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
>
>> David Woodhouse <dwmw2@infradead.org> writes:
>> > +
>> > +static struct dmi_system_id __initdata intel_iommu_dmi_table[] = {
>> > +	{	/* Some DG33BU BIOS revisions advertised
>> > non-existent VT-d */
>> 
>> Are you sure it's non existent? A G33 chipset should have it in
>> hardware I thought.
>
> nope they don't/
> later ones and some other models do though, but not the G33

I see. But presumably that chipset will be in other motherboards
too and that BIOS bug might be also wider spread. So it would be still 
better to key off an PCI-ID or similar.

-Andi

-- 
ak@linux.intel.com
