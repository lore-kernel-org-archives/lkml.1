Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbYKFQsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbYKFQsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYKFQrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:47:52 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:23271 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYKFQrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:47:52 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x86: mention ACPI in top-level Kconfig menu
Date: Thu, 6 Nov 2008 10:47:48 -0600
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>
References: <200811051237.28514.bjorn.helgaas@hp.com> <20081106071715.GJ15731@elte.hu>
In-Reply-To: <20081106071715.GJ15731@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811060947.48777.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 November 2008 12:17:15 am Ingo Molnar wrote:
> * Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > Mention ACPI in the top-level menu to give a clue as to where
> > it lives.  This matches what ia64 does.
> > 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> applied to tip/x86/urgent, thanks Bjorn!
> 
> small tweak:
> 
> > -menu "Power management options"
> > +menu "Power management and ACPI"
> 
> i changed it to "Power management and ACPI options".

OK.  The point of the patch was to remove needless differences
between x86 and ia64.  I'll update the Kconfig patch I sent
Tony yesterday so ia64 will say "Power management and ACPI options"
also.

Bjorn
