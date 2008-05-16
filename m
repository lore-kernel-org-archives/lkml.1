Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbYEPSlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbYEPSlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYEPSlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:41:40 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56570 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356AbYEPSlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:41:39 -0400
Date: Fri, 16 May 2008 14:41:38 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Message-ID: <20080516184138.GF27126@csclub.uwaterloo.ca>
References: <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <20080516132107.GA11304@csclub.uwaterloo.ca> <20080516161029.44ded734@core> <20080516173610.GA27126@csclub.uwaterloo.ca> <20080516191125.46f59ad6@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516191125.46f59ad6@core>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 07:11:25PM +0100, Alan Cox wrote:
> If they don't need that level of security they can use /dev/urandom.
> Piping network randomness into /dev/urandom is probably quite sensible
> but not into /dev/random.

Well it isn't that things liks ssh and ssl and such don't need that
level of security, but if there is no way to get it you have to go for
the best you can get.  Fortunately it seems hardware RNG is becoming
more common on embedded CPUs.

-- 
Len Sorensen
