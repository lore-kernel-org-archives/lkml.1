Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYFDErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYFDErS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYFDErJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:47:09 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:62474 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbYFDErI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:47:08 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:From:Organization:To:Subject:Date:User-Agent:Cc:
   References:In-Reply-To:MIME-Version:Content-Type:
   Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VuT3EZMn1LPy3p1QIBsb0bjl1qZf3jln4PwyYAeMGVz2kR0lCGvzT6Jh
   /29C6mrth6GZbgEpbvSWr6Wap4RrXiH9uTWqzaYstHc5hAT9X+CzT+XDl
   dWQz04t84c3uSE4;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.27,586,1204498800"; 
   d="scan'208";a="16190000"
X-IronPort-AV: E=Sophos;i="4.27,586,1204498800"; 
   d="scan'208";a="31203873"
From: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
Organization: IP BC E SW OS
To: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Who can backport the AHCI driver to older kernels
Date: Wed, 4 Jun 2008 06:47:02 +0200
User-Agent: KMail/1.9.5
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com> <alpine.LNX.1.10.0806031332410.4055@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0806031332410.4055@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806040647.03185.Rainer.Koenig@fujitsu-siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Am Dienstag, 3. Juni 2008 13:37 schrieb Jan Engelhardt:
> >The target market for those boards is using old fashioned
> > distributions like CentOS, Debian, Fedora 8 openSUSE 10 and so on.
>
> Wait a minute, that seems like an impossible dependency.
> These boards cannot be targeted for these distro versions,
> because the manufacturer knows (hopefully) that the shipped
> kernel versions do not have the driver with the required
> new code.

Yes, of course the manufacturer knows. But the customer wants to get the 
benefits from the new chipset technologie (e.g. support for quad core 
processors). The problem that we are facing is that we can't tell the 
customer "You cannot install actual Linux distributions", especially 
not when your customer is a firm that offers hosting services based on 
that platform. :-)

This is a general problem that we frequently face with Linux. Whenever a 
new piece of silicon is released it takes a while until the driver for 
that (even if it just requires the addition of a device ID) is reaching
the distributions. In the worst case the hardware platform will be "out 
of sale" when the driver finally hits the distributions. :-/

So in the actual case we really suffer from a chipset that is not fully 
supported by the distribution kernels. 

Thanks
Rainer
-- 
Dipl.-Inf. (FH) Rainer Koenig
Project Manager Linux Business Clients
Dept. IP BC E SW OS

Fujitsu Siemens Computers 
Bürgermeister-Ullrich-Str. 100
86199 Augsburg
Germany

Telephone: +49-821-804-3321
Telefax:   +49-821-804-2131
Mail:      mailto:Rainer.Koenig@fujitsu-siemens.com 

Internet         www.fujitsu-siemens.com
Company Details  www.fujitsu-siemens.com/imprint.html
