Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbYAaAV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbYAaAV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbYAaAVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:21:20 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:23100 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbYAaAVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:21:18 -0500
Date: Wed, 30 Jan 2008 18:20:34 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Help Needed Reading / Poling the ATA Status Register
In-reply-to: <c0cd3750-e4b0-4716-83a6-b7f8d7ef1156@y5g2000hsf.googlegroups.com>
To: "frank.priest@gmail.com" <frank.priest@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <47A11452.3030709@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <c0cd3750-e4b0-4716-83a6-b7f8d7ef1156@y5g2000hsf.googlegroups.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

frank.priest@gmail.com wrote:
> I am currently writing some code to send some ATA commands directly to
> the drive using ioctl and SG_IO which seems to work fine. However I
> also need to read the ATA status register values in real time which I
> am unsure how to do.
> 
> I have seen in the libata developers guide the following functions to
> read the status and alternative status registers:-
> 
> u8  (*check_status)(struct ata_port *ap);
> u8  (*check_altstatus)(struct ata_port *ap);
> u8  (*check_err)(struct ata_port *ap);
> 
> However I have no idea how to access these functions directly or even
> if this is the best way to go about it. Any help at all would be much
> appreciated.

First question is why you need to poll the status register, since quite 
likely there is a better solution to whatever that reason is..
