Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYCUMvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYCUMvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYCUMvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:51:40 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53539 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193AbYCUMvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:51:40 -0400
X-Sasl-enc: ptp4yatuBb7du1YPS5uYPkgx9/aFnxd/otlJKc2UX4SM 1206103898
Date: Fri, 21 Mar 2008 09:51:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Peter F. Patel-Schneider" <pfps@verizon.net>,
       Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>,
       Thomas Renninger <trenn@suse.de>
Subject: Reporting ThinkPad BIOS bugs
Message-ID: <20080321125135.GF5586@khazad-dum.debian.net>
References: <47067DB9.80200@roarinelk.homelinux.net> <47E300B2.7000104@verizon.net> <20080321011205.4c7b4a61@core> <47E31197.70003@gmail.com> <20080321104002.27a7d19e@core> <47E39963.2090908@verizon.net> <20080321111313.24567b9f@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321111313.24567b9f@core>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Alan Cox wrote:
> > How can I check to see if this is the case?  How would this explain that 
> 
> As I said before, take a CF card/adapter combination you know fails
> on a T60p/T61p and test it on a Linux box that isn't one of those types
> (and preferably not a Lenovo at all)
> 
> > the adapter and card sometimes work when they are in when the system boots?
> 
> Ask the BIOS authors. Trying to fathom what they have done is frequently

I can actually try to do just that.  So can Thomas Renninger, added to cc.

Please someone send either of us a *detailed*, ready for "upstream
submission" bug report of the thinkpad BIOS IRQ routing issues, and we might
be able to get it to someone who can fix it for good.

Be clear, concise, and remember that whomever will read it has no obligation
to know much about Linux kernel internals, so explain things from a
*hardware* and ACPI model (as in what is in the ACPI spec, not what ACPICA
code does) point of view.

Do attach the trimmed kernel logs showing the bugs and ACPI/IOAPIC init.
Even if the person reading the report doesn't know Linux well, they can be
helpful.  And if he does know Linux well...

The report should be done with the latest available BIOS when possible, and
include the dmidecode BIOS information (version, date), as well as the
dmidecode System Information/Product Name (i.e. the numeric model number).

Reports about non-Lenovo ThinkPad BIOSes are unlikely to be acted upon.  I
have made a bunch of those, but they couldn't do much about it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
