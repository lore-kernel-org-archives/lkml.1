Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbXGEWmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbXGEWmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbXGEWlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:41:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:36875 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759373AbXGEWlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:41:53 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, mjg59@srcf.ucam.org
In-Reply-To: <200707051048.46202.oliver@neukum.org>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com>
	 <200707051024.23528.oliver@neukum.org>
	 <E1I6Mtu-000058-00@dorka.pomaz.szeredi.hu>
	 <200707051048.46202.oliver@neukum.org>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 08:38:15 +1000
Message-Id: <1183675095.3388.72.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> There is that.
> 
> OK, bite the bullet. Tasks involved in fuse are special. Give them a flag
> and teach the freezer to put them on ice only after all other task are
> frozen. In a way they are kernel, there's no use denying that.

Yet another ugly hack to work around the fact that the freezer cannot
work reliably ... yuck

Why not spend that energy fixing drivers to properly block requests
instead ?

Ben.

