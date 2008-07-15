Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbYGOTdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbYGOTdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759005AbYGOTdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:33:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758967AbYGOTdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:33:01 -0400
Date: Tue, 15 Jul 2008 12:32:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807151228370.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl> <1216149637.27242.65.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Linus Torvalds wrote:
>
> [..] just make the kernel able to look up binary blobs in the same place 
> it installed them.

Obviously, we'd want to make it dynamically configurable, ie the same way 
we specify where to find 'modprobe', let people specify (in 
/proc/kernel/firmware-dir or something) where to find the firmware. Just 
default it to something sane (that obviously matches where we installed 
them).

I'm not a huge udevd fan, obviously. I think we can short-circuit this all 
in the name of expediency, with udevd as a fallback, not as the only way.

			Linus
