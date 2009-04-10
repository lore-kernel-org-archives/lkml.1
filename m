Return-Path: <linux-kernel-owner+w=401wt.eu-S937598AbZDJAkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937598AbZDJAkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 20:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937513AbZDJAjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 20:39:55 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:18993 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZDJAjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 20:39:52 -0400
X-IronPort-AV: E=Sophos;i="4.40,164,1238990400"; 
   d="scan'208";a="86081522"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: IRQF_SAMPLE_RANDOM question...
Date: Thu, 9 Apr 2009 20:41:29 -0400
User-Agent: KMail/1.9.5
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Chris Peterson" <cpeterso@cpeterso.com>
References: <200904061430.26276.rgetz@blackfin.uclinux.org> <200904090954.54601.rgetz@blackfin.uclinux.org> <1239296459.31467.142.camel@calx>
In-Reply-To: <1239296459.31467.142.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200904092041.29248.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 10 Apr 2009 00:39:09.0373 (UTC) FILETIME=[C2E25ED0:01C9B974]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 9 Apr 2009 13:00, Matt Mackall pondered:
> On Thu, 2009-04-09 at 09:54 -0400, Robin Getz wrote:
> > On Wed 8 Apr 2009 15:51, Matt Mackall pondered:
> > > On Tue, 2009-04-07 at 17:44 -0400, Robin Getz wrote:
> > > > Is that "Everything in general, with a few exceptions", or
> > > > "__Everything__"?
> > > 
> > > Everything. We want every input point to better document the type of
> > > entropy source.
> > 
> > OK - any objections to something like this?
> 
> Hmm, this is a purely internal interface. Not sure if we need to bother
> with scheduling it. My plan was to simply get the new code in and sweep
> the kernel. 

Yeah - it just stops people from putting in more places you need to change 
later.
