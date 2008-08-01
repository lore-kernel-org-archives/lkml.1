Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbYHAWhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbYHAWhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbYHAWhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:37:05 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53266 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756110AbYHAWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:37:03 -0400
X-Sasl-enc: 3ZKtW1QhOVbI/CjHIImonGmXVJWbWQqIRukW9A89WnYT 1217630221
Date: Fri, 1 Aug 2008 19:36:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
	shutdown
Message-ID: <20080801223657.GD23558@khazad-dum.debian.net>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <200807251319.12786.trenn@suse.de> <alpine.LFD.1.10.0807250948320.3884@localhost.localdomain> <alpine.LFD.1.10.0808011706350.3011@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808011706350.3011@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Aug 2008, Len Brown wrote:
> It is better to expose ourselves to the known tested Windows functionality
> -- even if it seems arbitrary, at least it is tested.  The !Windows case
> results in running _completely_ untested BIOS code.

Actually, we should masquerade properly as the latest Windows version
available for that machine, then.  AFAIK, Windows does not set ALL the OSI
strings, just one.  We ARE running untested code in some BIOSes because of
it.

Maybe it would be better if every ACPICA-using OS defined a
_OSI(NotWindows), plus the relevant Windows OSI string they want to support,
and Intel would send word that this string is to be used ONLY to disable all
Windows bug workarounds, not to activate or deactivate any specific
functionality?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
