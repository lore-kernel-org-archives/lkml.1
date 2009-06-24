Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbZFXPBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbZFXPBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZFXPBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:01:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39994 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751240AbZFXPBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:01:23 -0400
Date: Wed, 24 Jun 2009 11:01:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: Not able to read USB speed and descriptor
In-Reply-To: <241b8f7b0906240021p55d1721bt3fc74f2af7734e66@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0906241058480.3199-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Prabhu Chawandi wrote:

> In the devio.c,
> 
>   I have added  a case to return the speed and other descriptors,
> 
> call :
>  ret = usb_control_msg(pRootHub, usb_sndctrlpipe(pRootHub, 0),
>                USB_REQ_CLEAR_FEATURE, USB_RT_PORT, USB_PORT_FEAT_POWER,
>                port_num + 1, NULL, 0, HZ);
> 
> The above call is returning err : -32 EPIPE.
> 
> The above call is working file for the rear port while the same is not
> working for the fromt port.

Is this question related to $SUBJECT?  I don't see any connection...

> Anythig am I missing ? I am testing it for mass stoage device...

In most host controllers for personal computers, the hardware does not
support turning off port power.

Alan Stern

