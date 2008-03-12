Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbYCLFEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbYCLFEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYCLFEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:04:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48876 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYCLFEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:04:16 -0400
Date: Wed, 12 Mar 2008 06:04:15 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Prakhar Krishna <prakhar2@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: How to compile kernel so it automatically reboots upon a crash
 instead of generating stack trace and then hang.
In-Reply-To: <4f2ee0160803112152y21bb99a7t331fc9eff214e756@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803120602580.18745@fbirervta.pbzchgretzou.qr>
References: <4f2ee0160803112152y21bb99a7t331fc9eff214e756@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 11 2008 23:52, Prakhar Krishna wrote:
>
>[I did search the mailing lists archives and the Web but did not find an answer,
> apololgies if this is duplicate question]
>
>i need my linux box to automatically reboot if it ever runs into a
>kernel panic/crash etc.

panic=<timeout> boot parameter, as per 
Documentation/kernel-parameters.txt.

>For my production evvironment, it is not desired that kernel generate the stack
>trace and then wait there. We want it to reboot and comeback up again.

Kernel panic is not the only problem one can run into; there are
also deadlocks-after-oops situations, in which case some sort of
watchdog is best for triggering reboots.
