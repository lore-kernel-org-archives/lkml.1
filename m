Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbYBRB7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbYBRB7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYBRB7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:59:14 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33341 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbYBRB7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:59:13 -0500
X-Sasl-enc: zGSisb1uGf91kJMyiYDx4inlFJNMpWjdGRDmZ9a8wWEO 1203299951
Date: Sun, 17 Feb 2008 22:59:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: disable triggers on brightness set
Message-ID: <20080218015908.GC2096@khazad-dum.debian.net>
References: <1202380503.9519.21.camel@dax.rpnet.com> <20080207213845.GA27862@khazad-dum.debian.net> <1202422388.9519.123.camel@dax.rpnet.com> <20080207232309.GA2041@khazad-dum.debian.net> <47AEE587.6010601@freemail.hu> <1203291024.8272.106.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1203291024.8272.106.camel@dax.rpnet.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, Richard Purdie wrote:
> On Sun, 2008-02-10 at 12:52 +0100, Németh Márton wrote:
> > Disable any active triggers when the brightness attribute is
> > set to zero.
> 
> I agree with this approach and will merge this as a clarification of the
> interface, thanks. I'll also merge your other two patches into the LED
> queue.

Where can I get the queue?  I'd like to backport the patches (as merged by
you) to my various thinkpad-acpi backport trees, so that I can push the
thinkpad-acpi LED code to those trees for early testing...

I'd *really* recommend explicitly stating in the header file whether the
callbacks can or cannot be called from an interrupt context (i.e. "can they
sleep?").  And I sure hope it is "they can sleep", because otherwise, it
will be *hell* to implement them on any ACPI driver :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
