Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbYGPANR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbYGPANR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYGPANF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:13:05 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:38348 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753943AbYGPANE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:13:04 -0400
To: David Woodhouse <dwmw2@infradead.org>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	<20080714164119.99c33d5b.akpm@linux-foundation.org>
	<20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	<alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	<487C09EB.1050903@garzik.org>
	<alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
	<487C1648.5070409@garzik.org>
	<alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>
	<20080715050654.GH1369@1wt.eu>
	<1216099930.27455.205.camel@shinybook.infradead.org>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Tue, 15 Jul 2008 21:10:59 -0300
In-Reply-To: <1216099930.27455.205.camel@shinybook.infradead.org> (David Woodhouse's message of "Mon\, 14 Jul 2008 22\:32\:10 -0700")
Message-ID: <orskua1yek.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 15, 2008, David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2008-07-15 at 07:06 +0200, Willy Tarreau wrote:
>> This is just a matter of point of view. From my POV, having to feed
>> several unrelated files into a system to be able to get it to support
>> any device is moving backwards, compared to the currently clean
>> all-in-1 driver model.

> So you disapprove of having to load mac80211.ko before your wireless NIC
> driver? Or sungem_phy.ko before sungem.ko? Or libphy.ko before various
> other drivers?

Hey, how about a config option that turns firwmare files into
stand-alone kernel modules that register the blob into the
request_firmware internal list, and MODULE_FIRMWARE into a module
dependency?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
