Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZGIVif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZGIVif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbZGIVi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:38:26 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:7076 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbZGIViZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:38:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: David =?iso-8859-1?q?H=E4rdeman?= <david@hardeman.nu>
Subject: [PATCH 0/2] Winbond driver as PNP
Date: Thu, 9 Jul 2009 15:38:21 -0600
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, "Len Brown" <lenb@kernel.org>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu> <737c7bd0a2f550d21d45b347d018a1ac.squirrel@www.hardeman.nu> <200907081052.20142.bjorn.helgaas@hp.com>
In-Reply-To: <200907081052.20142.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907091538.21685.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009 10:52:19 am Bjorn Helgaas wrote:
> On Wednesday 01 July 2009 02:20:59 am David Härdeman wrote:
> > On Wed, July 1, 2009 01:11, Bjorn Helgaas wrote:
> > > The winbond driver does not use any ACPI-specific functionality, so
> > > it might be simpler to write it as a PNP driver (which would depend
> > > on PNPACPI, of course).
> > 
> > As far as I could tell from a quick look at include/linux/pnp.h, a
> > pnp_driver doesn't seem to have any .shutdown methods either, so I'm not
> > sure how it would help?
> 
> PNPACPI parses the device resources for you, so you could get rid
> of the _CRS stuff in your driver.
> 
> The only reason PNP and ACPI don't have .shutdown is because nobody
> has needed it yet.  If you need it (and it sounds like you do), I
> think the cleanest thing would be to add it to PNP and turn your
> driver into a PNP driver.

Here are two sample patches to show you what I was suggesting.  These
apply on top of the two Winbond patches currently in -mm.
