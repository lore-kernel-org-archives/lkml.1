Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab0BDTkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:40:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:59183 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363Ab0BDTko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:40:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,406,1262592000"; 
   d="scan'208";a="240560222"
Subject: Re: [PATCH] HPET: Drop WARN_ON for mismatch on HPET CMP readback
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100204193224.GA8957@basil.fritz.box>
References: <20100204191112.GA10135@basil.fritz.box>
	 <1265311335.16916.586.camel@localhost.localdomain>
	 <20100204193224.GA8957@basil.fritz.box>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 11:40:42 -0800
Message-Id: <1265312442.16916.588.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 11:32 -0800, Andi Kleen wrote:
> On Thu, Feb 04, 2010 at 11:22:15AM -0800, Pallipadi, Venkatesh wrote:
> > On Thu, 2010-02-04 at 11:11 -0800, Andi Kleen wrote:
> > >  HPET: Drop WARN_ON for mismatch on HPET CMP readback
> > >     
> > >     At least one Intel chipset seems to always return a constant value
> > >     when reading back the HPET CMP register. This triggers the WARN_ON_ONCE
> > >     on each boot.
> > 
> > I don't know of chipset returning a constant value. Which chipset is
> > this one?
> 
> Ibex Peak. That is I'm not sure it's fully constant, but at least
> it's always the same value on the HPET read triggering on boot.

OK. Yes. Ibexpeak is the same problem as ICH9, with reads not returning
the most recent write.

Thanks,
Venki


