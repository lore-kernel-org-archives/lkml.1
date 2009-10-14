Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbZJNLsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbZJNLsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 07:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932595AbZJNLsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 07:48:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33745 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932550AbZJNLsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 07:48:18 -0400
Date: Wed, 14 Oct 2009 12:48:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Michael Reed <mreed10@us.ibm.com>
Subject: Re: [PATCH] 8250_pci: Add IBM Saturn serial card
Message-ID: <20091014124825.21b4386c@lxorguk.ukuu.org.uk>
In-Reply-To: <1255477253.2347.22.camel@pasglop>
References: <1255477253.2347.22.camel@pasglop>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 10:40:53 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> The IBM Saturn serial card has only one port. Without that fixup,
> the kernel thinks it has two, which confuses userland setup and
> admin tools as well.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Looks good to me but can you drop a space between the last DEVICE_ID and
the VENDOR_ID bit in the header to follow the style ?

> ---
