Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0BKSHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:07:48 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54661 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab0BKSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:07:43 -0500
Date: Thu, 11 Feb 2010 18:07:15 +0000
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
Message-ID: <20100211180715.GA2147@srcf.ucam.org>
References: <4B7078E2.50407@dell.com> <1265911154.4689.11.camel@rex> <20100211180518.GB26117@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211180518.GB26117@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 10:05:19AM -0800, Dmitry Torokhov wrote:

> Or stuck it in dell-wmi.c...

I'd prefer not to put it in dell-wmi. There's no logical association 
between it and the rest of the code there, so it'd just be overhead on 
the majority of systems. With the exception of cases where the event and 
functional interfaces are different GUIDs, I'd prefer a one GUID per 
driver model.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
