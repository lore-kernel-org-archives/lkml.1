Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZFSREl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZFSREl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 13:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZFSREe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 13:04:34 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:62082 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZFSREd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 13:04:33 -0400
X-IronPort-AV: E=Sophos;i="4.42,254,1243828800"; 
   d="scan'208";a="383801"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: module version magic and arches with symbol prefixes
Date: Fri, 19 Jun 2009 13:07:45 -0400
User-Agent: KMail/1.9.5
CC: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <8bd0f97a0906180824y17a00110i57565aee16207e5@mail.gmail.com> <200906190854.13052.rgetz@blackfin.uclinux.org> <8bd0f97a0906190614x2ed27fcdrb59ea339eb45ba82@mail.gmail.com>
In-Reply-To: <8bd0f97a0906190614x2ed27fcdrb59ea339eb45ba82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200906191307.45135.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 19 Jun 2009 17:04:35.0800 (UTC) FILETIME=[05E5A580:01C9F100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 19 Jun 2009 09:14, Mike Frysinger pondered:
> On Fri, Jun 19, 2009 at 08:54, Robin Getz wrote:
> > On Fri 19 Jun 2009 01:38, Rusty Russell pondered:
> >> No, it means the kernel didn't build properly.
> >
> > Or a module didn't build properly.
> 
> nah, when i talked to you earlier i was wrong -- this find_symbol() is
> looking up the symbol in the kernel, not in the module.  the lookup of
> the symbol in the requested module actually works.

OK - Yeah, I see it now in the kernel proper. (sorry for the noise)

Wouldn't it make sense to move this somewhere else then? and add a 
__initcall() for it? We should only need to check for it once - it would make 
things insignificantly faster, and smaller :)

