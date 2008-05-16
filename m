Return-Path: <linux-kernel-owner+w=401wt.eu-S1763930AbYEPAIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763930AbYEPAIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 20:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbYEPAH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 20:07:56 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57336 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755873AbYEPAHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 20:07:55 -0400
X-Sasl-enc: 5gloVNmYHigNCUVGNmGYpX3yLF4sx3MdpBKO1zfNLCqt 1210896474
Date: Thu, 15 May 2008 21:07:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, jeremy@xensource.com,
       Herbert Xu <herbert@gondor.apana.org.au>, Avi Kivity <avi@qumranet.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: Virt RNG?
Message-ID: <20080516000751.GC23721@khazad-dum.debian.net>
References: <482C8595.5030509@garzik.org> <200805160943.08788.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805160943.08788.rusty@rustcorp.com.au>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Rusty Russell wrote:
> Yes, I prepared one earlier.  I was a little surprised to see that hwrng 
> drivers don't contribute in any way to the entropy pool though, but now
> reading the thread I find out about rngd (not installed on my Ubuntu system, 
> but available at least).

It would be easy to implement rng-tools as a kernel driver, as long as
proper in-kernel interfaces exist for it to work in an event-driven way.
I don't see what we would win over rng-tools in userspace, however.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
