Return-Path: <linux-kernel-owner+w=401wt.eu-S933525AbYGQXXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbYGQXXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbYGQXXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:23:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37634 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760790AbYGQXXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:23:21 -0400
Date: Fri, 18 Jul 2008 01:23:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Thomas Lucaw <aj881@chebucto.ns.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: ide-cd or ide-scsi dmesg contradiction
In-Reply-To: <Pine.LNX.4.64.0807171844330.1320@ttl.localnet>
Message-ID: <alpine.LNX.1.10.0807180119460.12734@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0807171844330.1320@ttl.localnet>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 2008-07-18 00:11, Thomas Lucaw wrote:

>Hi, for some time I've noticed
>
>giving the cmdline (to kernel at boot) "hdd=ide-scsi ..." I get
>
>	ide-scsi is deprecated for cd burning! Use ide-cd and give
>	dev=/dev/hdX as device
>
>then changing to the suggested "hdd=ide-cd ..." I get

There is a subtle difference between dev=/dev/hdX and hdd=ide-cd.

>	ide_setup: hdc=ide-cd -- OBSOLETE OPTION, WILL BE REMOVED SOON!
>
>Rather illogical to me :-)
>
>I guess neither should be used, I can make my cdrom and dvd devices work 
>without ok.

Right, neither.

	cdrecord dev=/dev/sr0 (or dev=/dev/hdc) whichever is appropriate

is all one needs. I guess you can even use /dev/sg0.
Care to send a patch?
