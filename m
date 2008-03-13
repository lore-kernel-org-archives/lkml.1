Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYCMN0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYCMN0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYCMNZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:25:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbYCMNZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:25:46 -0400
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc5
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080313125541.GA7365@v2.random>
References: <200803130214.36861.lenb@kernel.org>
	 <20080312234516.bb079cc5.akpm@linux-foundation.org>
	 <1205391105.2240.68.camel@acpi-hp-zz.sh.intel.com>
	 <20080313125541.GA7365@v2.random>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 13 Mar 2008 14:25:37 +0100
Message-Id: <1205414737.29877.366.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-13 at 13:55 +0100, Andrea Arcangeli wrote:
> On Thu, Mar 13, 2008 at 02:51:45PM +0800, Zhang, Rui wrote:
> > Well, the patch looks good, this may be caused by a BIOS problem.
> > anyway, I wish to get the response from Andrea so that I can do some
> > investigation ASAP.
> 
> Here attached again. syslog isn't available because by the time it
> crash netconsole isn't up yet, but I try to compile it as module and
> see if it crashes by loading it manually later after netconsole
> started. (you didn't ask for syslog until today)
> 
> Hardware is ASUS M2A-VM ACPI BIOS Revision 1604.
This is pretty sure fixed in 2.6.25-rc5.
 
It's probably this:
https://bugzilla.novell.com/show_bug.cgi?id=350017
It's fixed by:
c8d16e27a3601d1cbcdfe657eb4ff5e762019e8d
-> fixing the memory corruption
b6a163875935ce8e8e85901a7f2b68f7a314d914
-> check the pointer which is now not corrupted anymore, but NULL.

Hmm, the commits are only in Len's tree and have not hit
Linus' tree yet.

   Thomas

> email message attachment
> > -------- Forwarded Message --------
> > From: Andrea Arcangeli <andrea@qumranet.com>
> > To: Zhang, Rui <rui.zhang@intel.com>
> > Cc: Thomas, Sujith <sujith.thomas@intel.com>, Brown, Len
> > <len.brown@intel.com>
> > Subject: Re: thermal.c crash at boot
> > Date: Thu, 21 Feb 2008 15:55:56 +0100
> > 
> > On Mon, Feb 18, 2008 at 09:15:13AM +0800, Zhang, Rui wrote:
> > > Please attach the acpidump output.
> > 
> > attached.
> > 

