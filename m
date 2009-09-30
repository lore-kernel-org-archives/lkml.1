Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZI3S1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZI3S1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 14:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZI3S1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 14:27:49 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:22431 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbZI3S1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 14:27:48 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH] cmpc_acpi: Added support for Classmate PC ACPI devices.
Date: Wed, 30 Sep 2009 12:27:48 -0600
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, don@syst.com.br,
       linux-acpi@vger.kernel.org
References: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com> <200909300950.39332.bjorn.helgaas@hp.com> <20090930175141.GG17475@vespa.holoscopio.com>
In-Reply-To: <20090930175141.GG17475@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909301227.49916.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 September 2009 11:51:43 am Thadeu Lima de Souza Cascardo wrote:
> On Wed, Sep 30, 2009 at 09:50:38AM -0600, Bjorn Helgaas wrote:
> > On Monday 28 September 2009 07:38:00 pm Thadeu Lima de Souza Cascardo wrote:
> > > This add supports for devices like keyboard, backlight, tablet and
> > > accelerometer.
> > 
> > Something about the PNP IDs bothered me yesterday, but I couldn't
> > figure out what.  You're using:
> > 
> >   ACCE0000
> >   TBLT0000
> >   IPML200
> >   FnBT0000
> > 
> > Normally these OEM-specific ACPI drivers claim PNP IDs like ATK0100,
> > TOS6200, FUJ02B1, etc., that are obviously OEM-specific.
> > 
> > But the ones you're claiming seem pretty generic, like things
> > we could imagine appearing on machines other than the Classmate.
> > 
> > So I guess my question is, "Are these really generic?  If so, should
> > this be split into separate, non-Classmate named drivers, such as
> > 'accelerometer', 'tablet', etc.?"
> > 
> 
> Although I agree that {ATK,TOS,FUJ,IBM}* give pretty much a certainty
> these are OEM-specific, I think we'd need some evidence that
> {ACCE,TBLT,IPML,FnBT}* are generic enough to grant them a non-classmate
> driver.
> 
> What I mean is that we should push this driver forward and turn these
> into a generic driver if we get some evidence these are not
> Classmate-specific. And that will happen when we hit some other system
> with these devices.

Yep, I agree with you that it's not worth splitting things up until
we find these devices on more systems.  Just out of curiosity, where
did you find specs for these devices?  If there's a public spec, it'd
be nice to have a pointer to it in the driver.

Bjorn
