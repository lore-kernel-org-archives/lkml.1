Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbZLDRGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbZLDRGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbZLDRGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:06:19 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38886 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644AbZLDRGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:06:18 -0500
Date: Fri, 4 Dec 2009 09:06:21 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, lenb@kernel.org
Cc: Crane Cai <crane.cai@amd.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2 1/2] acpi: support IBM SMBus CMI devices
Message-ID: <20091204170621.GA10356@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20091021173733.GN26149@tux1.beaverton.ibm.com> <20091022071748.GA17917@crane-desktop> <20091022174304.GO26149@tux1.beaverton.ibm.com> <20091023044451.GB1367@crane-desktop> <20091023170311.GC21723@tux1.beaverton.ibm.com> <20091025125353.55d3bfad@hyperion.delvare> <20091026205819.GR26149@tux1.beaverton.ibm.com> <20091027180332.62f2c758@hyperion.delvare> <20091027173001.GT26149@tux1.beaverton.ibm.com> <20091027183619.16b0b952@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027183619.16b0b952@hyperion.delvare>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 06:36:19PM +0100, Jean Delvare wrote:
> On Tue, 27 Oct 2009 10:30:01 -0700, Darrick J. Wong wrote:
> > On Tue, Oct 27, 2009 at 06:03:32PM +0100, Jean Delvare wrote:
> > 
> > > I'm only half please with this. You change the function named, but it
> > > doesn't follow the calling convention of acpi_dock_match(), which is a
> > > little confusing.
> > > 
> > > Anyway, I will need an ack from the ACPI people before I can pick this
> > > patch. Or maybe they should even push it upstream themselves.

Len/Bjorn: Any opinion on this ACPI quirk patch to make i2c-scmi work on IBM
systems?  I think the i2c-scmi part is in Jean's tree, but I still need this
second patch to the ACPI code itself.  Did you pick it up, or should I resend?

--D
