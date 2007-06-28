Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbXF1H5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbXF1H5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 03:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760434AbXF1H52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 03:57:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60765 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666AbXF1H51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 03:57:27 -0400
X-Sasl-enc: mrSwpnULy2UaAX/VU2eL6AajETGMiosYJCiIvkviMUWU 1183017446
Date: Thu, 28 Jun 2007 04:57:19 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_random: add quality categories
Message-ID: <20070628075719.GA13258@khazad-dum.debian.net>
References: <200706241555.22957.mb@bu3sch.de> <200706271458.51884.mb@bu3sch.de> <20070627164041.GA6508@khazad-dum.debian.net> <200706271956.29244.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706271956.29244.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Michael Buesch wrote:
> On Wednesday 27 June 2007 18:40:41 Henrique de Moraes Holschuh wrote:
> > There *is* a much better way to deal with it, though.  Add the fail always
> > RNG device, and always select it by default.  Let the user specifically set
> > which RNG he wants, and it now rates as "trusted", which is the only
> > fail-proof way to go about it IMHO.
> 
> Well, but it changes ABI, which is forbidden.
> After a kernel update your system will partially not work anymore.

<shrug>.  At least it will not be doing anything dangerous, and it is a ABI
*fix*, so you are not just changing it for the kicks of it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
