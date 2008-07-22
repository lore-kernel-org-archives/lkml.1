Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbYGVVRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbYGVVRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbYGVVOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:14:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbYGVVOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:14:47 -0400
Date: Tue, 22 Jul 2008 17:14:41 -0400
From: Rik van Riel <riel@redhat.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 128 GiB memory question-- kernel only sees 64GiB?
Message-ID: <20080722171441.6daee243@bree.surriel.com>
In-Reply-To: <alpine.DEB.1.10.0807221655140.11681@p34.internal.lan>
References: <alpine.DEB.1.10.0807221019570.8455@p34.internal.lan>
	<20080722104327.30cee9be@bree.surriel.com>
	<alpine.DEB.1.10.0807221655140.11681@p34.internal.lan>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 16:55:32 -0400 (EDT)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> On Tue, 22 Jul 2008, Rik van Riel wrote:
> 
> > On Tue, 22 Jul 2008 10:21:44 -0400 (EDT)
> > Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >
> >> To be able to utilize 128 GiB of memory on a host, does one need to enable
> >> NUMA support? Currently only 64 GiB is showing up.
> >
> > How much memory does the BIOS say the system has?
> Asked them.
> 
> >
> > Can you get the e820 memory map (from early boot up) of the systems?
> Probably can't get this.

It looks roughly like this:

BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 00000000bfb50000 (usable)
 BIOS-e820: 00000000bfb50000 - 00000000bfb66000 (reserved)
 BIOS-e820: 00000000bfb66000 - 00000000bfb85c00 (ACPI data)
 BIOS-e820: 00000000bfb85c00 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000440000000 (usable)

Getting this info will be very useful.
 
-- 
All rights reversed.
