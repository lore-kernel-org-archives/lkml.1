Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZBNWEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZBNWEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZBNWEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:04:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44242 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbZBNWEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:04:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Morten P.D. Stevens" <mstevens@win-professional.com>
Subject: Re: linux 2.6.29-rc3 kernel failure with mptsas
Date: Sat, 14 Feb 2009 23:03:59 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <B4ED8DE8E195E84A872496A085BC07822F11@exchange01.corp.win-professional.com> <20090206155038.67847521.akpm@linux-foundation.org> <B4ED8DE8E195E84A872496A085BC07822F2E@exchange01.corp.win-professional.com>
In-Reply-To: <B4ED8DE8E195E84A872496A085BC07822F2E@exchange01.corp.win-professional.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902142304.00339.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 February 2009, Morten P.D. Stevens wrote:
> Update:
> 
> today i installed linux 2.6.29-rc5 and there a no problems?
> 
> no errors or kernel failures in dmesg.
> 
> linux 2.6.29-rc5 works fine but something is strange:
> 
> > -	init_timer(&pCfg->timer);
> > +	init_timer_on_stack(&pCfg->timer);
> 
> this wasn't changed?
> 
> Anyway it´s working fine with 2.6.29-rc5, now.

Thanks for the update.  I'm going to close this bug.

Rafael
