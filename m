Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbYGOUSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbYGOUSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYGOUR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:17:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYGOUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:17:57 -0400
Date: Tue, 15 Jul 2008 13:17:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <1216152609.27242.99.camel@violet.holtmann.net>
Message-ID: <alpine.LFD.1.10.0807151316180.2867@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>  <1216150616.27455.377.camel@shinybook.infradead.org>  <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
  <1216151866.26991.4.camel@shinybook.infradead.org> <1216152609.27242.99.camel@violet.holtmann.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Marcel Holtmann wrote:
> 
> So Ubuntu will obviously not break since it does this already. For
> Fedora deploying new packages for 8 and 9 should not be a problem at all
> once the maintainer is convinced that it is a good idea. They update
> packages all the time anyway. For the other distros, I don't know.

Umm. Again, Marcel. We don't require new user land to work.

But just loading the thing on our own does solve this problem. But udev we 
simply cannot require people to magically have a new version of.

		Linus
