Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbZJNVC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbZJNVC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZJNVC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:02:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:36388 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903AbZJNVC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:02:58 -0400
Subject: Re: [PATCH] 8250_pci: Add IBM Saturn serial card
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Michael Reed <mreed10@us.ibm.com>
In-Reply-To: <20091014124825.21b4386c@lxorguk.ukuu.org.uk>
References: <1255477253.2347.22.camel@pasglop>
	 <20091014124825.21b4386c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Oct 2009 08:01:36 +1100
Message-Id: <1255554096.2347.53.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 12:48 +0100, Alan Cox wrote:
> On Wed, 14 Oct 2009 10:40:53 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > The IBM Saturn serial card has only one port. Without that fixup,
> > the kernel thinks it has two, which confuses userland setup and
> > admin tools as well.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Looks good to me but can you drop a space between the last DEVICE_ID and
> the VENDOR_ID bit in the header to follow the style ?

Ok. It was between the last IBM device ID and the IBM subvendor, I
wasn't sure if that warranted a blank line :-)

I'll send a new patch from work.

Cheers,
Ben.



