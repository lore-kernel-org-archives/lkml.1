Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab0BKSbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:31:16 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34019 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab0BKSbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:31:15 -0500
Date: Thu, 11 Feb 2010 18:31:03 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Bob Rodgers <Robert_Rodgers@dell.com>,
       "lenb@kernel.org" <lenb@kernel.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>,
       Michael Brown <Michael_E_Brown@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>, Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] Add Dell Business Class Netbook LED driver
Message-ID: <20100211183103.GB2605@srcf.ucam.org>
References: <4B7078E2.50407@dell.com> <1265911154.4689.11.camel@rex> <20100211180518.GB26117@core.coreip.homeip.net> <20100211180715.GA2147@srcf.ucam.org> <20100211182829.GA26659@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211182829.GA26659@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 10:28:30AM -0800, Dmitry Torokhov wrote:

> This is an opposite direction form the rest of the platform drivers
> which tend to combine functionality on per-vendor basis in one driver.

I don't think that's true - we /tend/ to see one driver per ACPI device 
or device interface (see the dell-wmi/dell-laptop split, for instance).

> I'd say that in this case with this LED driver overhead on DELL systems
> not supportinfg it is miniscule. The benefit is that all vendor-specific
> sub-devices are children of one parent platform device.

I really don't see that as a strong benefit.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
