Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbZLJDx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbZLJDx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 22:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759521AbZLJDxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 22:53:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:44681 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759507AbZLJDxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 22:53:24 -0500
Subject: Re: [PATCH] cardbus: Add a fixup hook and fix powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, blofeldus@yahoo.com,
       Olof Johansson <olof@lixom.net>
In-Reply-To: <20091209213736.GA25968@comet.dominikbrodowski.net>
References: <1260341533.16132.20.camel@pasglop>
	 <20091209213736.GA25968@comet.dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Dec 2009 14:53:16 +1100
Message-ID: <1260417196.16132.110.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 22:37 +0100, Dominik Brodowski wrote:
> Acked-by: Dominik Brodowski <linux@dominikbrodowski.net> (for PCMCIA)
> 
> > Note: In the long run we might want to streamline the hooks for fixing
> > up new devices vs. new busses and make some stuff common between cardbus
> > and PCI hotplug which is actually a mess.
> 
> ... though I'd prefer such a generic approach. 

Thanks. Yes that would be better. I don't have the bandwidth right now
to look at that though, maybe early next year.

Cheers,
Ben.


