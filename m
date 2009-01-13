Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZAMGsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZAMGsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZAMGs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:48:26 -0500
Received: from mail.openmoko.org ([88.198.124.205]:43854 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZAMGs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:48:26 -0500
Date: Tue, 13 Jan 2009 12:17:45 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, sameo@openedhand.com
Subject: Re: [PATCH V3 0/7] PCF50633 support
Message-ID: <20090113064743.GA3218@fedora.yogi>
References: <20090105181242.7559.30087.stgit@fedora.yogi> <20090112144434.eeb1640d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112144434.eeb1640d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 02:44:34PM -0800, Andrew Morton wrote:
> On Mon, 05 Jan 2009 23:42:42 +0530
> Balaji Rao <balajirrao@openmoko.org> wrote:
> 
> > The following series implements support for NXP PCF50633. It's basically
> > an I2C device with 9 regulators, an ADC, a PMIC, a Battery Charger
> > and a RTC.
> > 
> > This chip is used in Openmoko Neo Freerunner mobile phone.
> > 
> > The specs are open and are available at 
> > http://people.openmoko.org/tony_tu/GTA02/datasheet/PMU/PCF50633DS_02.pdf
> > 
> > ---
> > Balaji Rao (7):
> >       mfd: PCF50633 core driver
> >       mfd: PCF50633 adc driver
> >       mfd: PCF50633 gpio support
> >       rtc: PCF50633 rtc driver
> >       power_supply: PCF50633 battery charger driver
> >       input: PCF50633 input driver
> >       regulator: PCF50633 pmic driver
> 
> You have patches here which should strictly be merged by various
> different subsystem trees.  That gets tricky because presumably there
> are dependencies.
> 
> What _are_ the dependencies here?  Do patches 2-7 depend upon #1, perhaps?
> 

yes, patches 2-7 depend on the first one.

> If so, then one approach would be to merge the first patch into
> mainline now then trickle the rest out into subsystem trees.
> 
> Or, with suitable acks, I can merge the lot.  Perhaps into 2.6.29..
> 

Andrew,

Samuel had sent a git-pull for the linux-mfd tree containing this series a couple
of days ago and now I see that it's merged. So, I think you can remove
these from -mm.

Thanks,
Balaji
