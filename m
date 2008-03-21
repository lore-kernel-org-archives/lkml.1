Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYCUNqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYCUNqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYCUNqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:46:44 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:54001 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYCUNqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:46:43 -0400
Date: Fri, 21 Mar 2008 09:40:58 -0400 (EDT)
Message-Id: <20080321.094058.111958759.pfps@research.bell-labs.com>
To: hmh@hmh.eng.br
Cc: alan@lxorguk.ukuu.org.uk, pfps@verizon.net, htejun@gmail.com,
       linux-kernel@vger.kernel.org, trenn@suse.de
Subject: Re: Reporting ThinkPad BIOS bugs
From: "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
In-Reply-To: <20080321125135.GF5586@khazad-dum.debian.net>
References: <47E39963.2090908@verizon.net>
	<20080321111313.24567b9f@core>
	<20080321125135.GF5586@khazad-dum.debian.net>
X-Mailer: Mew version 5.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2008 13:45:13.0567 (UTC) FILETIME=[C9E57EF0:01C88B59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great.

I'm willing to do what is needed to get this moving along, if someone
tells me what is needed.

It does appear that the problem is specific to particular machines, as
my Lenovo T60p running BIOS version 2.21 of 02/05/2008 (up to date as of
yesterday) has the problem when running various kernels (including all
Fedora 8, currently 2.6.24.3-34.fc8, and Fedora 9 alpha kernels,
currently some 2.6.25 kernel).  However, everything works fine on a
Compac EVO N620c running from the Fedora 8 Live CD.

I have standard kernel logs with the behaviors, including a full bootup
log (when the device works).  I just got the dmidecode information.  

If anyone wants, I can send you this information (about 900 lines), or I
can get other information.  I also can (with a bit of difficulty
probably get information from a T60 and an X60).

peter


From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Reporting ThinkPad BIOS bugs
Date: Fri, 21 Mar 2008 09:51:35 -0300

> On Fri, 21 Mar 2008, Alan Cox wrote:
> > > How can I check to see if this is the case?  How would this explain that 
> > 
> > As I said before, take a CF card/adapter combination you know fails
> > on a T60p/T61p and test it on a Linux box that isn't one of those types
> > (and preferably not a Lenovo at all)
> > 
> > > the adapter and card sometimes work when they are in when the system boots?
> > 
> > Ask the BIOS authors. Trying to fathom what they have done is frequently
> 
> I can actually try to do just that.  So can Thomas Renninger, added to cc.
> 
> Please someone send either of us a *detailed*, ready for "upstream
> submission" bug report of the thinkpad BIOS IRQ routing issues, and we might
> be able to get it to someone who can fix it for good.
> 
> Be clear, concise, and remember that whomever will read it has no obligation
> to know much about Linux kernel internals, so explain things from a
> *hardware* and ACPI model (as in what is in the ACPI spec, not what ACPICA
> code does) point of view.
> 
> Do attach the trimmed kernel logs showing the bugs and ACPI/IOAPIC init.
> Even if the person reading the report doesn't know Linux well, they can be
> helpful.  And if he does know Linux well...
> 
> The report should be done with the latest available BIOS when possible, and
> include the dmidecode BIOS information (version, date), as well as the
> dmidecode System Information/Product Name (i.e. the numeric model number).
> 
> Reports about non-Lenovo ThinkPad BIOSes are unlikely to be acted upon.  I
> have made a bunch of those, but they couldn't do much about it.
