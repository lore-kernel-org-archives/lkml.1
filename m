Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYAXAEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYAXAEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYAXAEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:04:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:9560 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYAXAEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:04:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=O2HUX9aQpbzU0JYP/z9z3ts68Mhq+mLtspkbMR8g4wfDbUX2cEDzOtHfSGSJtNUrWs1r9K6rSNpeVzvZEJtx92KPdTj1ShXiFrqmORrlP5WWVci3GqLbnqDrpayfTXWJq5ckmUDAzlAIxOydRxpu6nE84k+RfSnJUEQe1vYUS8s=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Silent crash witk 2-6.24-rc8-git4
Date: Thu, 24 Jan 2008 00:03:31 +0000
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <200801220603.02986.chris2553@googlemail.com> <200801231642.58782.chris2553@googlemail.com> <20080123190207.GB3129@tuxdriver.com>
In-Reply-To: <20080123190207.GB3129@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801240003.31666.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply, John.

On Wednesday 23 January 2008, John W. Linville wrote:
> On Wed, Jan 23, 2008 at 04:42:58PM +0000, Chris Clayton wrote:
> > On Wednesday 23 January 2008, Chris Clayton wrote:
> > > Hi again.
> > > 
> > > On Tuesday 22 January 2008, Chris Clayton wrote:
> > > > Hi,
> > 
> > and here's another, slightly more complete, one, this time from 2.6.24-rc8-git6
> > (the none I sent earlier was from -git4, by the way)
> > 
> > Call Trace:
> > [<c011440a>] __update_rq_clock+0x1a/0xf0
> > [<e08ff59d>] rt2x00lib_txdone+0x9d/0xd0 [rt2x00lib]
> > [<e0909573>] rt61pci_txdone+0x153/0x1f0 [rt61pci]
> > [<e09096ad>] rt61pci_interrupt+0x9d/0xb0 [rt61pci]
> 
> I suspect this could relate to this commit:
> 
> commit 62bc060b8ed5fcdafd87da5ab17bdd59a39ebcc9
> Author: Mattias Nissler <mattias.nissler@gmx.de>
> Date:   Mon Nov 12 15:03:12 2007 +0100
> 
>     rt2x00: Allow rt61 to catch up after a missing tx report
> 
> Could you revert that patch, rebuild, and try to recreate the problem?
> 

I've reverted the patch by hand - the original patch on linux-wireless doesn't match the present state of the code
in rt61pci.c and I'm not a git user. I'm pretty sure I've got it right, however.

Problem now is that we are back where we were a few weeks ago because my wireless connection dies
almost immediately after I start the download and from dmesg I see:

phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 2.
Please file bug report to http://rt2x00.serialmonkey.com.

Chris

> Thanks!
> 
> John



-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
