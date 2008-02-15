Return-Path: <linux-kernel-owner+w=401wt.eu-S1764545AbYBON1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764545AbYBON1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYBON04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:26:56 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37410 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbYBON0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:26:55 -0500
Date: Fri, 15 Feb 2008 14:27:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 00/14] [ISDN] HiSax hotplug conversion
Message-ID: <20080215132703.GG1178@uranus.ravnborg.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 11:04:04PM -0400, Jeff Garzik wrote:
> 
> This is a refresh of an on-going work-in-progress:  convert the last
> remaining users of pci_find_device() to the ISA/PCI/etc.  hotplug APIs
> now in standard use.  After SCSI's gdth, ISDN's HiSax suite of drivers
> are just about the last place using the older API.
> 
> A few rough edges remain, and I'm not sure how much of ISDN userland
> will explode (I have no ISDN hardware, nor much want any:)), but this
> should get us almost all the way there.
> 
> The patches are diff'd against 2.6.25-rc1.
> 
> Comments/review/testing welcome.  Especially "it works" or "its dead"
> testing.

Just ran checkpatch for the fun of it:
total: 28 errors, 86 warnings, 4896 lines checked
Most looks easy to fix.

Anyone with minimal interest in isdn could do so - hint!

	Sam
