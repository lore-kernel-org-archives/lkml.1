Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYIAWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYIAWf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYIAWfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:35:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:42284 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYIAWfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:35:18 -0400
Date: Mon, 1 Sep 2008 15:35:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Misc fixes for 2.6.27
Message-ID: <20080901153517.2f8b1ef8@infradead.org>
In-Reply-To: <87wshvwl8v.fsf@basil.nowhere.org>
References: <1220300084.2982.139.camel@pmac.infradead.org>
	<87wshvwl8v.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008 00:32:16 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> David Woodhouse <dwmw2@infradead.org> writes:
> > +
> > +static struct dmi_system_id __initdata intel_iommu_dmi_table[] = {
> > +	{	/* Some DG33BU BIOS revisions advertised
> > non-existent VT-d */
> 
> Are you sure it's non existent? A G33 chipset should have it in
> hardware I thought.

nope they don't/
later ones and some other models do though, but not the G33
> 
> I'm not sure this is really the right way to handle this anyways.
> If there's ever a working BIOS it will be blacklisted too. And
> normally BIOS bugs don't come in one board alone, but in a range
> of them and then adding more and more identifiers is quite painful.

the bios bug here is that it accidentally DID advertise the capability,
even though it's not there.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
