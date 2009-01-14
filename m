Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZANDbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZANDbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZANDbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:31:10 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:37407 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZANDbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:31:09 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=VsOVpn7lMGqlQ3oLYjkA:9 a=HORoOqQp9DHuxdKRS1Nvsl2xPIsA:4 a=kNAwe-3CODUA:10 a=XK7UU1QYhjMA:10
Message-ID: <496D5C7A.9040505@shaw.ca>
Date: Tue, 13 Jan 2009 21:31:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: RHubbell@iHubbell.com
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: USB memory card reader and 64MB SD card - 2.6.28-git14
References: <1231621530.4495.36.camel@127> <49693575.2030007@shaw.ca> <1231829328.19241.3.camel@127>
In-Reply-To: <1231829328.19241.3.camel@127>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rhubbell wrote:
> Darn, I meant to respond to the list also.
> Anyway there is no dmesg output for the card. 
> The dmesg output looks correct with the 128MB card.
> 
> Here's for the 128:
> scsi0 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> scsi 0:0:0:0: Direct-Access              USB Card Reader  1.01 PQ: 0 ANSI: 0 CCS
> sd 0:0:0:0: [sda] 251904 512-byte hardware sectors: (128 MB/123 MiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
> sd 0:0:0:0: [sda] Assuming drive cache: write through
> sd 0:0:0:0: [sda] 251904 512-byte hardware sectors: (128 MB/123 MiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
> sd 0:0:0:0: [sda] Assuming drive cache: write through
>  sda: sda1
> sd 0:0:0:0: [sda] Attached SCSI removable disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> usb-storage: device scan complete

That output seems rather normal.. If you're not getting anything like 
that with the other card though, I would tend to suspect some kind of 
issue with the card, the reader or some kind of incompatibility between 
them. Certainly all the USB resets from the other output would tend to 
suggest the reader isn't responding properly with that card installed..
