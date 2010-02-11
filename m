Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0BKSJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:09:51 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54685 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab0BKSJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:09:49 -0500
Date: Thu, 11 Feb 2010 18:09:42 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Bob Rodgers <Robert_Rodgers@dell.com>, "lenb@kernel.org" <lenb@kernel.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>,
       Michael Brown <Michael_E_Brown@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>, Dan Carpenter <error27@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Add Dell Business Class Netbook LED driver
Message-ID: <20100211180942.GA2244@srcf.ucam.org>
References: <4B7078E2.50407@dell.com> <1265911154.4689.11.camel@rex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265911154.4689.11.camel@rex>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 05:59:14PM +0000, Richard Purdie wrote:
> > +config LEDS_DELL_NETBOOKS
> > +	tristate "External LED on Dell Business Netbooks"
> > +	depends on LEDS_CLASS
> > +	help
> > +	  This adds support for the Latitude 2100 and similar
> > +	  notebooks that have an external LED.
> > +
> >  comment "LED Triggers"
> 
> I assume this driver applies to X86 only? Is there anything else this
> config option should be depending on?

Sorry for not catching that. It ought to depend on ACPI_WMI as well.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
