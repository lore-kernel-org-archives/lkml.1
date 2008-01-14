Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYANKdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYANKdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYANKdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:33:09 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:57314 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYANKdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:33:07 -0500
X-SBRS: None
X-MesageID: 37611095
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,281,1196658000"; 
   d="scan'208";a="37611095"
Date: Mon, 14 Jan 2008 10:24:28 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Default keyboard LEDs
Message-ID: <20080114102428.GA4298@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080114005219.GA4296@implementation> <Pine.LNX.4.64.0801140238260.10906@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0801140238260.10906@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt, le Mon 14 Jan 2008 02:40:08 +0100, a écrit :
> On Jan 14 2008 00:52, Samuel Thibault wrote:
> >In many cases, one prefers to have e.g. the NumLock on by default.  In
> >many cases, one doesn't want to have it by default, e.g. on laptops.
> >
> >Distributions actually have a very hard time trying to set this
> >correctly after the kernel boot, and that doesn't work for new consoles
> >that are created via the openvt(1) command anyway. This hence adds a
> >keyboard.default_leds boot parameter that permits to configure the
> >default keyboard LEDs.
> 
> Apart from openvt being able to find the first unused tty,
> what is openvt good for? (Read: I could just as well run
> `bash </dev/tty8 >/dev/tty8 2>/dev/tty8`)

But it is a burden (you forgot '&' btw ;) ). Also, openvt properly sets
the controlling tty, can run a login shell, etc...

Anyway, be it openvt or bash, the LED issue exists :)

Samuel
