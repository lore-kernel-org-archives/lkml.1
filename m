Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbYAaHWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbYAaHWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYAaHVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:21:54 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:43485 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752129AbYAaHVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:21:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zRdi4OXF7wc5bDh3mVNl7YubrF9iUyPTC1GlYeJHuKD9yBaK3+zg7aUJj792pkdfjrMG05BPu8HUkw6eCDNLMfeKn8dRcP23EeaK+iAVp5sRVI+NnQZuF0cdC8IsnPq3JmIlC+wGSjHO+02ZoCfrSiFckd+t6qLf+kYsx/PIJHQ=  ;
X-YMail-OSG: x80en24VM1kEs_RsBu1nZjRSy7JUReVW6CwExLRNY144MLZh4OZC4zfXaQ4tCoE8gRU0C2wi3A--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [spi-devel-general] SPI related Kconfig warning
Date: Wed, 30 Jan 2008 23:21:50 -0800
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       eric miao <eric.y.miao@gmail.com>
References: <D5CED6F1-A708-4866-BA3D-75F3CCBA43F6@kernel.crashing.org>
In-Reply-To: <D5CED6F1-A708-4866-BA3D-75F3CCBA43F6@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801302321.51120.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008, Kumar Gala wrote:
> Was wondering if anyone was looking at the cause of this warning in  
> top of linus's tree (8af03e782cae1e0a0f530ddd22301cdd12cf9dc0)
> 
> drivers/spi/Kconfig:156:warning: 'select' used by config symbol  
> 'SPI_PXA2XX' refers to undefined symbol 'PXA_SSP'
> 
> I was doing a build of a ppc kernel.

Happens on x86, AVR32, and non-PXA ARM too.  Came from some PXA cleanup
patches.  Eric, didn't you have a patch for this?

(Of course I *still* don't understand why kconfig bothers to look
at reverse dependencies whose "forward" ones can never be satisfied.
If it stopped looking at those, lots of similar problems would vanish.)

- Dave
