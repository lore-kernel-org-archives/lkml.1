Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYHBRuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYHBRuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYHBRuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:50:06 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55428 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbYHBRuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:50:04 -0400
X-Sasl-enc: aKf1+e8fyaWbuwhhqOt1blZkfo9VUPjrL5RFnUZlm41p 1217699403
Date: Sat, 2 Aug 2008 14:49:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>, Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
	shutdown
Message-ID: <20080802174958.GA20430@khazad-dum.debian.net>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <200807251319.12786.trenn@suse.de> <alpine.LFD.1.10.0807250948320.3884@localhost.localdomain> <alpine.LFD.1.10.0808011706350.3011@localhost.localdomain> <20080801223657.GD23558@khazad-dum.debian.net> <20080802054204.GB12646@srcf.ucam.org> <20080802143833.GC14069@khazad-dum.debian.net> <20080802154114.GA28879@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802154114.GA28879@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Aug 2008, Matthew Garrett wrote:
> On Sat, Aug 02, 2008 at 11:38:33AM -0300, Henrique de Moraes Holschuh wrote:
> > > Not all BIOSes would support this, so we'd need to support the Windows 
> > > workarounds anyway. At that point, there's no real benefit in having 
> > > multiple codepaths.
> > 
> > Sorry, but I will disagree.
> > 
> > Anything that can help in the future with the vendors that are better at
> > Linux support is a good thing.  You are right that we will still have to
> > deal with the others, but there are such things as vendor-specific windows
> > workarounds (they didn't want to change their firmware, or they couldn't, or
> > the others didn't care to add the workaround, etc).  If that vendor uses the
> > "NotWindows" OSI correctly, we would not need to take any special action.
> 
> Allowing vendors to special-case Linux means that we have to have a 
> special-case path for the minority of vendors who ask for this. It's 
> added complexity and we don't actually gain anything from it.

Correction: special case ALL non-windows.  There's a reason why I said
ACPICA should provide OSI(NonWindows).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
