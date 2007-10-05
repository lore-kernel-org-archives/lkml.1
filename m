Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbXJETzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbXJETzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbXJETzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:55:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56810 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbXJETzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:55:19 -0400
Date: Fri, 5 Oct 2007 21:55:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
In-Reply-To: <20071005194326.GD4000@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0710052144580.13406@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
 <20071005191940.GA4003@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0710052120270.13406@fbirervta.pbzchgretzou.qr>
 <20071005192404.GB4003@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0710052126271.13406@fbirervta.pbzchgretzou.qr>
 <20071005194326.GD4000@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 5 2007 15:43, Lennart Sorensen wrote:
>On Fri, Oct 05, 2007 at 09:32:11PM +0200, Jan Engelhardt wrote:
>> Ah you seem to be a proponent of http://www.blackgoogle.com/
>> then :-)  Unfortunately, it seems like Xft uses Grayscale AA
>> (http://antigrain.com/research/font_rasterization/index.html)
>> so black background make the font look thinner.
>
>I was mainly thinking someone with a server with a screen showing their
>console might like to not make too much heat in the server room.

"Ha, ok, I see where you're going with this one."

This patch is perfectly suited to reduce heat at home and in the server
room, especially during kernel development and debugging, but the
average kernel usage already pays off. Just add vt.printk_color=0x08
and all your kernel messages and oopses will be printed using low-power
electrons. Extremely useful on SGI Altix 4700, which does print a lot
(number of CPU cores), or SunFire X4500 (number of disks). Even if not
using one of these systems, CKO can contribute to the lower power usage
of PetaBox™ [http://www.archive.org/web/petabox.php]... ;-)
