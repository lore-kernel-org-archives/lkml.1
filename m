Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYKJRtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYKJRtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYKJRsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:48:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbYKJRst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:48:49 -0500
Message-ID: <491873FE.2030408@zytor.com>
Date: Mon, 10 Nov 2008 09:48:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?TWlndWVsIMOBbmdlbCDDgWx2YXJleg==?= 
	<gotzoncabanes@gmail.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: EHCI "on the go"
References: <b0438a630811100347s2d228f2cu26610f7279eb083f@mail.gmail.com>
In-Reply-To: <b0438a630811100347s2d228f2cu26610f7279eb083f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Ángel Álvarez wrote:
> Hi.
> 
> Due to some problems with the EHCI in an IXP465, I have found that
> this micro has an "on the go" feature. One of its features seems to be
> an "Embedded Transaction Translator", that seems to be quite
> "propietary".
> 
> I see in ehci.h, that using CONFIG_USB_EHCI_ROOT_HUB_TT, a function
> called "ehci_port_speed" has been added, and the comments suggest to
> implement the particularities of each controller with other functions.
> 
> The question is:
> - Are there many different implementations (it seems there are not,
> because I cannot see code for each of them... unless they are so
> particular that they do not even use the general interface)?
> - Is there any place comparing the similarities / differences between them?
> 

I only know of one interface for this, which is based on hardware IP I
believe is currently owned by ChipIdea.  It's pretty straightforward; it
functionally does the same translation for the root port as a separate
hub would do for a full speed/low speed downstream port.

	-hpa
