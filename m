Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbXKTS7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbXKTS7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbXKTS7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:59:30 -0500
Received: from mx1.suse.de ([195.135.220.2]:40251 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbXKTS7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:59:30 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: trenn@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] PNP cleanups - Unify the pnp macros to access resources in the pnp resource table
From: Andi Kleen <andi@firstfloor.org>
References: <1195552283.23700.166.camel@queen.suse.de>
	<20071120123102.03bdaa67@the-village.bc.nu>
	<1195568360.23700.202.camel@queen.suse.de>
	<20071120151404.4332d0d4@the-village.bc.nu>
Date: Tue, 20 Nov 2007 19:59:28 +0100
In-Reply-To: <20071120151404.4332d0d4@the-village.bc.nu> (Alan Cox's message of "Tue\, 20 Nov 2007 15\:14\:04 +0000")
Message-ID: <p73abp8bv5b.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>
> Is it actually even worth changing in the first place ? You seem to be
> complicating the code not simplyifying it, and at the end of the day
> ISAPnP is obsolete and BIOS PnP is obsoleted by ACPI

The PNP interface is used by the ACPI code to tell the various
non PCI drivers about their resources.  Thomas is actually
aiming at some ACPI issues with this.

-Andi
