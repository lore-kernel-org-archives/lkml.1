Return-Path: <linux-kernel-owner+w=401wt.eu-S1767266AbXCING7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767266AbXCING7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767265AbXCING7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:06:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:48164 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767266AbXCING6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:06:58 -0500
Subject: Re: [patch 2.6.20-1] radeonfb: Add support for Radeon xpress 200m
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: johan henriksson <jhn98032@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <45F062E1.8050007@gmail.com>
References: <45ECB2D0.3080205@telia.com> <45EEEBC9.1010002@redhat.com>
	 <45EF275E.4060300@gmail.com> <45F03305.8040507@redhat.com>
	 <45F062E1.8050007@gmail.com>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 14:00:34 +0100
Message-Id: <1173445234.24454.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> -		radeonfb_pm_init(rinfo, rinfo->is_mobility ? 1 : -1, ignore_devlist, force_sleep);
> +		radeonfb_pm_init(rinfo, rinfo->is_mobility && rinfo->family != CHIP_FAMILY_RS480 ? 1 : -1, ignore_devlist, force_sleep);

I'd rather you add a check for RS480 inside radeonfb_pm_*

Ben.


