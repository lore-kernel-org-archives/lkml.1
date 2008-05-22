Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbYEVRPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbYEVRPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYEVRPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:15:42 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:41869 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752645AbYEVRPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:15:41 -0400
Date: Thu, 22 May 2008 18:15:33 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: David Miller <davem@davemloft.net>, Matheos.Worku@Sun.COM,
       yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
Message-ID: <20080522171531.GZ28241@solarflare.com>
References: <4824CBA1.8040703@sun.com> <4824CCF0.5050302@krogh.cc> <4824D1E1.10007@sun.com> <20080509.154538.28321777.davem@davemloft.net> <4835A007.7020601@krogh.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4835A007.7020601@krogh.cc>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> David Miller wrote:
> >From: Matheos Worku <Matheos.Worku@Sun.COM>
> >Date: Fri, 09 May 2008 15:36:17 -0700
> >
> >>I have observed TX throughput degradation (and increased CPU 
> >>utilization)  occurs with increased # of connections, when CPU count > 4 
> >>CPUs.  I don't think it is related to the driver (or HW).
> >
> >All transmits through a device are fully serialized currently,
> >it's a known problem and something we plan to fix.
> 
> I google'd up this one:
> 
> http://vger.kernel.org/~davem/davem_tokyo08.pdf (slide 23+).
> 
> Does this mean that I can expect every 10G card to have this limitation
> under Linux? Or are some known to be better than others?
> (I can probably justify paying for another 10G card if I can expect to
> gain the last 400MB/s).
[...]

Our controller and driver can reach line rate for a single TCP/IPv4 stream,
depending on the host system.  I don't think we're alone in that, though
there are few published benchmarks that don't involve TOEs.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
