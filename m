Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYHaROV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYHaROV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbYHaRON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:14:13 -0400
Received: from ns1.suse.de ([195.135.220.2]:45281 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbYHaROM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:14:12 -0400
From: Thomas Renninger <trenn@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [ANNOUNCE] ACPI BIOS Guideline for Linux
Date: Sun, 31 Aug 2008 15:18:24 +0200
User-Agent: KMail/1.9.9
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807241732.23412.trenn@suse.de> <200808291729.53628.trenn@suse.de> <20080830124713.GA5910@srcf.ucam.org>
In-Reply-To: <20080830124713.GA5910@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311518.25421.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 August 2008 02:47:13 pm Matthew Garrett wrote:
> On Fri, Aug 29, 2008 at 05:29:52PM +0200, Thomas Renninger wrote:
> > On Thursday 28 August 2008 14:22:29 Matthew Garrett wrote:
> > > Little. But what advantage do we get in the same functionality being
> > > implemented in an entirely custom way? Even less.
> >
> > It is all about documentation, right.
> > WMI is complicating things by one needless and complicated layer.
>
> Not really. It provides approximately no complexity for Linux drivers,
> and makes it easier for vendors to provide Windows support. WMI has not
> been the hard bit of the drivers I've written. I don't see any reason to
> ask vendors not to use it,
Autoloading does not work yet?
It is working fine with ordinary ACPI devices providing a HID.
> as long as they're willing to document their 
> implementation.
I'll point that out, something like:
If you really have to use WMI for Windows compatibility reason, make
sure the important parts (is there already something to mention?
Against what is the driver loaded -> autoloading?) are documented well.

      Thomas
