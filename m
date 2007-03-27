Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbXC0C1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbXC0C1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 22:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933956AbXC0C1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 22:27:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34151 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955AbXC0C1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 22:27:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Mitch Williams <mitch.a.williams@intel.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
References: <1174951102.22190.15.camel@strongmad>
	<20070327000951.GA11555@kroah.com>
Date: Mon, 26 Mar 2007 20:26:57 -0600
In-Reply-To: <20070327000951.GA11555@kroah.com> (Greg KH's message of "Mon, 26
	Mar 2007 17:09:51 -0700")
Message-ID: <m18xdj1kwe.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> How well does this play with the MSI core changes that Michael Ellerman
> has proposed on the linux-pci mailing list?

The patch looks reasonable and it is independent of those changes.

This just modifies the helper code for using the msi capability itself as
an interrupt controller.   Other architectures that mask/unmask the interrupt
at an architecture specific interrupt controller  won't be affected.

Eric
