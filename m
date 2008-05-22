Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYEVSOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYEVSOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbYEVSOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:14:30 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:41963 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755975AbYEVSOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:14:30 -0400
Date: Thu, 22 May 2008 19:14:21 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
Cc: jesper@krogh.cc, Matheos.Worku@Sun.COM, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
Message-ID: <20080522181420.GB28241@solarflare.com>
References: <4824D1E1.10007@sun.com> <20080509.154538.28321777.davem@davemloft.net> <4835A007.7020601@krogh.cc> <20080522.104145.193700531.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522.104145.193700531.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jesper Krogh <jesper@krogh.cc>
> Date: Thu, 22 May 2008 18:32:07 +0200
> 
> > Does this mean that I can expect every 10G card to have this limitation
> > under Linux?
> 
> For now, yes.  The transmit path itself in the generic network
> device layer is where the serialization comes from.

This is true in the general case, but can be substantially mitigated
by segmentation offload.  Unfortunately GSO doesn't help much as the
overhead of allocating the extra skbs is fairly high.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
