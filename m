Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab0BDTc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:32:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49561 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0BDTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:32:26 -0500
Date: Thu, 4 Feb 2010 20:32:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HPET: Drop WARN_ON for mismatch on HPET CMP readback
Message-ID: <20100204193224.GA8957@basil.fritz.box>
References: <20100204191112.GA10135@basil.fritz.box> <1265311335.16916.586.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265311335.16916.586.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 11:22:15AM -0800, Pallipadi, Venkatesh wrote:
> On Thu, 2010-02-04 at 11:11 -0800, Andi Kleen wrote:
> >  HPET: Drop WARN_ON for mismatch on HPET CMP readback
> >     
> >     At least one Intel chipset seems to always return a constant value
> >     when reading back the HPET CMP register. This triggers the WARN_ON_ONCE
> >     on each boot.
> 
> I don't know of chipset returning a constant value. Which chipset is
> this one?

Ibex Peak. That is I'm not sure it's fully constant, but at least
it's always the same value on the HPET read triggering on boot.

> 
> http://marc.info/?l=linux-kernel&m=125849385330302&w=2
> 
> I wanted to send out final patch with a pointer to ICH9/10 spec update
> which describes the errata. But, look like that spec update hasn't
> happened yet. As we found issue with atleast one chipset with this
> warn_on, I would prefer retaining it, with a fix like above.

Ok fine for me. I only really care that the ugly backtrace
goes away.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
