Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbZLDRgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbZLDRgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932337AbZLDRgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:36:32 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1736 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbZLDRgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:36:31 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: djwong@us.ibm.com
Subject: Re: [PATCH v2 1/2] acpi: support IBM SMBus CMI devices
Date: Fri, 4 Dec 2009 10:36:35 -0700
User-Agent: KMail/1.9.10
Cc: lenb@kernel.org, Crane Cai <crane.cai@amd.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
References: <20091021173733.GN26149@tux1.beaverton.ibm.com> <20091027183619.16b0b952@hyperion.delvare> <20091204170621.GA10356@tux1.beaverton.ibm.com>
In-Reply-To: <20091204170621.GA10356@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912041036.36686.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009 10:06:21 am Darrick J. Wong wrote:
> On Tue, Oct 27, 2009 at 06:36:19PM +0100, Jean Delvare wrote:
> > On Tue, 27 Oct 2009 10:30:01 -0700, Darrick J. Wong wrote:
> > > On Tue, Oct 27, 2009 at 06:03:32PM +0100, Jean Delvare wrote:
> > > 
> > > > I'm only half please with this. You change the function named, but it
> > > > doesn't follow the calling convention of acpi_dock_match(), which is a
> > > > little confusing.
> > > > 
> > > > Anyway, I will need an ack from the ACPI people before I can pick this
> > > > patch. Or maybe they should even push it upstream themselves.
> 
> Len/Bjorn: Any opinion on this ACPI quirk patch to make i2c-scmi work on IBM
> systems?  I think the i2c-scmi part is in Jean's tree, but I still need this
> second patch to the ACPI code itself.  Did you pick it up, or should I resend?

I'm a little confused as to where we left things.  Can you repost
the current series in a new thread?  It looks like there might be
places that use "SMBUSIBM" when they should use ACPI_SMBUS_IBM_HID.

Bjorn
