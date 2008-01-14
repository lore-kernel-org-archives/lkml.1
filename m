Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYANBkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYANBkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYANBkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:40:10 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:59694 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYANBkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:40:09 -0500
Date: Mon, 14 Jan 2008 02:40:08 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Default keyboard LEDs
In-Reply-To: <20080114005219.GA4296@implementation>
Message-ID: <Pine.LNX.4.64.0801140238260.10906@fbirervta.pbzchgretzou.qr>
References: <20080114005219.GA4296@implementation>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 14 2008 00:52, Samuel Thibault wrote:
>
>In many cases, one prefers to have e.g. the NumLock on by default.  In
>many cases, one doesn't want to have it by default, e.g. on laptops.
>
>Distributions actually have a very hard time trying to set this
>correctly after the kernel boot, and that doesn't work for new consoles
>that are created via the openvt(1) command anyway. This hence adds a
>keyboard.default_leds boot parameter that permits to configure the
>default keyboard LEDs.

Apart from openvt being able to find the first unused tty,
what is openvt good for? (Read: I could just as well run
`bash </dev/tty8 >/dev/tty8 2>/dev/tty8`)
