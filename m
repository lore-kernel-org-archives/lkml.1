Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYCaBB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYCaBB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 21:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYCaBBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 21:01:19 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:13836 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYCaBBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 21:01:18 -0400
Date: Sun, 30 Mar 2008 18:59:13 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Again... DMA speed too slow
In-reply-to: <fa.kS8AgwgGnOORqOO36Liq2hSrgfI@ifi.uio.no>
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
Cc: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Message-id: <47F03761.4090801@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.kS8AgwgGnOORqOO36Liq2hSrgfI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> Hi all...
> 
> I have tried to burn some data from the commandline with wodim (since time
> ago I just used beasero...), and I have noticed this (media is CD, not DVD):
> 
> Vendor_info    : 'HL-DT-ST'
> Identification : 'DVDRAM GSA-H10N '
> Revision       : 'JL12'
> Device seems to be: Generic mmc2 DVD-R/DVD-RW.
> Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
> Driver flags   : MMC-3 SWABAUDIO BURNFREE
> Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R
> Speed set to 8467 KB/s
> wodim: DMA speed too slow (OK for 5x). Cannot write at speed 48x.
> Starting to write CD/DVD at speed  48.0 in real TAO mode for single session.
> 
> I just can burn CDs at 5x ??
> But then the program tries to write at 48x.
> It the DMA message really true ?

No, UDMA33 should be more than fast enough. My guess is that wodim is 
determining the DMA speed using some unreliable mechanism.
