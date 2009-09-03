Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZICUQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZICUQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbZICUQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:16:55 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:54973 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756196AbZICUQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:16:55 -0400
From: Frans Pop <elendil@planet.nl>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Thu, 3 Sep 2009 22:16:54 +0200
User-Agent: KMail/1.9.9
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Christian =?utf-8?q?Kr=C3=A4mer?= <christian@kraemer-eu.de>,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <200909021856.29565.christian@kraemer-eu.de> <alpine.LFD.2.00.0909031539070.3200@localhost> <20090903195753.GC11097@pengutronix.de>
In-Reply-To: <20090903195753.GC11097@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909032216.56148.elendil@planet.nl>
X-OriginalArrivalTime: 03 Sep 2009 20:16:56.0626 (UTC) FILETIME=[7C28F120:01CA2CD3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009, Wolfram Sang wrote:
> I read the thread in which you tried. I will have my try, too. This
> time, I want to convert the existing users first and then throw the
> interface away. To me, it looks like there is only one prominent user
> left, Debian's discover. Even though the PCMCIA-information it collects
> is hardly useful, I converted it:
>
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=382425
>
> Still working on getting any response from the maintainers :)

I'm a Debian Developer and one of the developers of Debian's installation 
system. My suggestion would be to simply ignore discover. It is not used 
anymore and the fact that it's un(der)maintained does not surprise me.

A simple follow-up to the bug report announcing the removal of the old 
interface per kernel version X would be appreciated. If it actually 
results in a build failure, it will probably get updated quickly enough. 
The available patch will help with that.

Cheers,
FJP
