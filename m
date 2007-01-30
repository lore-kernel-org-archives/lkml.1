Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXA3PvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXA3PvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965098AbXA3PvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:51:15 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:6717 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965158AbXA3PvO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:51:14 -0500
Message-ID: <45BF6950.4080007@tungstengraphics.com>
Date: Tue, 30 Jan 2007 16:50:40 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
       =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Support for i386 PATs
References: <45BB1952.8000903@tungstengraphics.com> <20070128214832.GD23903@redhat.com>
In-Reply-To: <20070128214832.GD23903@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Sat, Jan 27, 2007 at 10:20:18AM +0100, Thomas Hellström wrote:
>  > Hi!
>  > 
>  > Does anybody have a strong opinion against adding support for
>  > i386 Page Attribute Tables?
>
> It pops up about once a year, everyone agrees it'd be a good idea,
> and then nothing happens.  Last year, I started picking over
> Terrence Ripperda's original implementation, but that needs a bit
> of work. (http://lkml.org/lkml/2005/5/12/187)
> Whoa, two years even.  Time flies.
>
> 		Dave
>
>   
Ah.
This might explain why nothing happens :).

I had something much simpler in mind.
Just the basic PAT setup and some new pgprot_ types which affected 
drivers could use directly.

Like in(drivers/char/drm/drm_vm.c) where ia64 has a 
pgprot_writecombine() function.

/Thomas




