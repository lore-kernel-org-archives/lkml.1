Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbZLDSHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbZLDSHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbZLDSHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:07:11 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53937 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbZLDSHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:07:10 -0500
Date: Fri, 4 Dec 2009 10:07:07 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: lenb@kernel.org, Crane Cai <crane.cai@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
       linux-acpi@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2 1/2] acpi: support IBM SMBus CMI devices
Message-ID: <20091204180707.GM10295@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20091021173733.GN26149@tux1.beaverton.ibm.com> <20091027183619.16b0b952@hyperion.delvare> <20091204170621.GA10356@tux1.beaverton.ibm.com> <200912041036.36686.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912041036.36686.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 10:36:35AM -0700, Bjorn Helgaas wrote:
> On Friday 04 December 2009 10:06:21 am Darrick J. Wong wrote:
> > On Tue, Oct 27, 2009 at 06:36:19PM +0100, Jean Delvare wrote:
> > > On Tue, 27 Oct 2009 10:30:01 -0700, Darrick J. Wong wrote:
> > > > On Tue, Oct 27, 2009 at 06:03:32PM +0100, Jean Delvare wrote:
> > > > 
> > > > > I'm only half please with this. You change the function named, but it
> > > > > doesn't follow the calling convention of acpi_dock_match(), which is a
> > > > > little confusing.
> > > > > 
> > > > > Anyway, I will need an ack from the ACPI people before I can pick this
> > > > > patch. Or maybe they should even push it upstream themselves.
> > 
> > Len/Bjorn: Any opinion on this ACPI quirk patch to make i2c-scmi work on IBM
> > systems?  I think the i2c-scmi part is in Jean's tree, but I still need this
> > second patch to the ACPI code itself.  Did you pick it up, or should I resend?
> 
> I'm a little confused as to where we left things.  Can you repost
> the current series in a new thread?  It looks like there might be
> places that use "SMBUSIBM" when they should use ACPI_SMBUS_IBM_HID.

That was fixed in the patch that Jean picked up, which is why I especially need
the ACPI portion which actually #defines ACPI_SMBUS_IBM_HID. :)  I will repost
both patches soon.

--D
