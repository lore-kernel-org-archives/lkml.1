Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbYEEPCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbYEEPCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYEEPCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:02:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780AbYEEPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:02:21 -0400
Date: Mon, 5 May 2008 08:01:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Jan Engelhardt <jengelh@medozas.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
In-Reply-To: <481F1EB3.3040906@garzik.org>
Message-ID: <alpine.LFD.1.10.0805050801120.32269@woody.linux-foundation.org>
References: <200805051455.02723.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org> <alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0805050735150.32269@woody.linux-foundation.org>
 <481F1EB3.3040906@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 May 2008, Jeff Garzik wrote:
> 
> Most kernel hacker situations probably don't need this, but a modern distro
> these days _does_ want critical-to-boot stuff in initrd like LVM bootstrap
> programs, iSCSI discovery, Bluetooth userland management, etc.

Right. Which is why I build the stuff into my kernel that is required, and 
then initrd can do whatever it damn well pleases.

			Linus
