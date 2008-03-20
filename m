Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbYCTPTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbYCTPTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbYCTPTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:19:37 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38245 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756282AbYCTPTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:19:36 -0400
X-Sasl-enc: l26aRkIyhQq2dybDAwFUQw+l6dDd7qeFdnvxUJ3G+/UC 1206026374
Date: Thu, 20 Mar 2008 12:19:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation
	patchset against -rc6)
Message-ID: <20080320151931.GD5615@khazad-dum.debian.net>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318232037.GA1670@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080318232037.GA1670@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, Pavel Machek wrote:
>     Also, for polling mode to work on Acers, we need
>     to insert a delay.

Can we, in the future, always trigger any such performance damaging "fixups"
based on DMI white/black lists?  As a rule?

This is not the first time I see a vendor push broken crap, and everyone
else who did it right get the shaft, because people don't like to add
quirks to common code.  We get performance enhancement features disabled,
mdelays added...

And for the do-as-windows-does crowd, they do it on vendor­issued device
drivers, which obviously don't hork everyone else's devices.  Our equivalent
solution is to key things to DMI matches.   This is worth keeping in mind,
because the ACPI subsystem seems to be a common target for such bad
behaviour.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
