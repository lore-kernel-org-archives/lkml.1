Return-Path: <linux-kernel-owner+w=401wt.eu-S1762282AbYGOCl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282AbYGOCl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbYGOCke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:40:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40378
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761949AbYGOCkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:40:31 -0400
Date: Mon, 14 Jul 2008 19:40:32 -0700 (PDT)
Message-Id: <20080714.194032.117461306.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	<487C09EB.1050903@garzik.org>
	<alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Jul 2008 19:33:25 -0700 (PDT)

> 
> 
> On Mon, 14 Jul 2008, Jeff Garzik wrote:
> > 
> > My complaints are about --not breaking stuff--, not request_firmware().
> 
> Guys, request_firmware() has been around for about five years now.

Jeff's not against request_firmware() in an of itself.

He's against the fact that it's not possible to build a
self-contained foo.ko module file any longer, and that
would definitely be possible with using request_firmware().
