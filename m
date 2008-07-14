Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYGNUI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYGNUI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757992AbYGNUIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:08:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45916 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367AbYGNUIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:08:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Date: Mon, 14 Jul 2008 22:10:41 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200807010148.02135.rjw@sisk.pl> <200807132229.43140.rjw@sisk.pl> <487ABB81.8020100@zytor.com>
In-Reply-To: <487ABB81.8020100@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807142210.43035.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of July 2008, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> > 
> > If s3_bios depends on the (invalid) contents of the hidden part of any segment
> > register, it's just terminally broken.
> > 
> 
> Depending on it being in Big Real Mode isn't all that broken, however, 
> especially on laptops where the vendor has control over the system 
> BIOS/video BIOS.
> 
> Enabling BRM by default *shouldn't* break anything, so it might be what 
> we want to do anyway.

Agreed.
