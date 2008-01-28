Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYA1JWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYA1JWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYA1JVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:21:55 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:65168 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752792AbYA1JVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:21:54 -0500
Date: Mon, 28 Jan 2008 10:21:49 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Question about DMA
Message-ID: <20080128102149.545c0619@dhcp-252-066.norway.atmel.com>
In-Reply-To: <38b2ab8a0801280055j6d1d235boe79e6aea058f8f96@mail.gmail.com>
References: <38b2ab8a0801271251v1a9ea256w8fa4b9fcc620f742@mail.gmail.com>
	<479D06E0.3090601@gmail.com>
	<38b2ab8a0801280055j6d1d235boe79e6aea058f8f96@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 09:55:58 +0100
"Francis Moreau" <francis.moro@gmail.com> wrote:

> My DMA controller has very little in common with ISA DMA one. But I'd like to
> use it in a driver. This driver can do DMA but with the help of an external DMA
> controller. It's only implement the "slave" side. So basically this driver needs
> to configure one of the DMAC channels before transfering data.

Have a look at this thread:

http://lkml.org/lkml/2007/11/23/79

I'm planning to post an updated patch set this week that addresses the
comments by Dan Williams, and that applies on top of the other DMA
Engine patches that have been posted since then.

Please let me know if you think this will work for your hardware. What
platform are you working on, btw?

Haavard
