Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993Ab0A1BgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab0A1BgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971Ab0A1BgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:36:12 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:58185 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755967Ab0A1BgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:36:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=V2c52K79rX8WlYDR8oOrlHLlaImrGJhvGM92S26Xc95QbCBLvUfV7pNhe1ANYTxJpmroF0R7gA3jfimiRFcyax8IXqcANLsRt1LJrEvedWyMXQj5rox4y7E01WLMROQG;
Date: Wed, 27 Jan 2010 17:35:50 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Myron Stowe <myron.stowe@hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100127173550.14737320@jbarnes-piketon>
In-Reply-To: <4B5F735B.2040308@kernel.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	<201001261348.59508.rjw@sisk.pl>
	<201001261032.37053.bjorn.helgaas@hp.com>
	<201001261902.13911.rjw@sisk.pl>
	<20100126101752.78196900@jbarnes-piketon>
	<4B5F735B.2040308@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 14:57:31 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On 01/26/2010 10:17 AM, Jesse Barnes wrote:
> 
> > 
> > For 2.6.33 I'd like a minimal fix though, can you disable it for all
> > but the multi-IOH case perhaps?
> > 
> please check,
> 
> [PATCH] x86/pci: don't use ioh resource if only have one ioh
> 
> some system could use reosurce out of IOH resources when only one ioh is there.
> 
> could be BIOS have wrong IOH resources and not enable them.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I applied this one to my for-linus branch.  Jeff can you confirm it
works for you?  I'd like to push it to Linus tomorrow.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
