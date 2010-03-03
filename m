Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0CCNqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 08:46:33 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50532 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0CCNqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:46:32 -0500
Date: Wed, 3 Mar 2010 13:46:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@novell.com>,
       Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 57/62] msi-laptop: Add threeg sysfs file for support
	query 3G state by standard 66/62 ec command
Message-ID: <20100303134631.GB28349@srcf.ucam.org>
References: <20100302230933.GA32287@kroah.com> <1267572541-410-57-git-send-email-gregkh@suse.de> <20100302233616.GA13739@srcf.ucam.org> <20100302234700.GB1680@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302234700.GB1680@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 03:47:00PM -0800, Greg KH wrote:
> On Tue, Mar 02, 2010 at 11:36:16PM +0000, Matthew Garrett wrote:
> > On Tue, Mar 02, 2010 at 03:28:56PM -0800, Greg Kroah-Hartman wrote:
> > 
> > > Add threeg sysfs file for support query 3G state by standard 66/62 ec
> > > command, the MSI standard ec interface supported this feature.
> > 
> > No. Just use the rfkill interface.
> 
> Does rfkill support 3G?  I thought it was only for wireless (80211)
> stuff.

rfkill has types for the majority of radios. A later patch adds the 3g 
rfkill device, so this one should just be dropped - there's no reason to 
add a non-standard radio control file now.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
