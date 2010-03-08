Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0CHTsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:48:13 -0500
Received: from isilmar.linta.de ([213.133.102.198]:52036 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754623Ab0CHTsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:48:00 -0500
Date: Mon, 8 Mar 2010 20:47:57 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Jan Beulich <JBeulich@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, alan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia's use of IRQ_NOAUTOEN
Message-ID: <20100308194757.GB17628@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Jan Beulich <JBeulich@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>, alan@linux.intel.com,
	linux-kernel@vger.kernel.org
References: <4B94DCB7020000780003337B@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B94DCB7020000780003337B@vpn.id2.novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Mar 08, 2010 at 10:17:11AM +0000, Jan Beulich wrote:
> (re-sending to correct Alan's email address)
> 
> Commit 635416ef393e8cec5a89fc6c1de710ee9596a51e introduced
> this, but I can't see how it can take effect - the argument passed to
> request_irq() only affects action->flags (IRQF_*), whereas the flag
> in question is a desc->status one (IRQ_*). Am I overlooking
> something? If not, while currently this just should not work as expected,
> it's latently more significant (as soon as the IRQF_* definitions make
> use of the bit used by IRQ_NOAUTOEN).

You're right, it seems to make no sense. Or less than that.

Alan, what do you think?

Best,
	Dominik
