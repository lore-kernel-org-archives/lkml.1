Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbXLTShs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbXLTShs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbXLTShk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:37:40 -0500
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:64001 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753936AbXLTShj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:37:39 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: David Newall <david@davidnewall.com>
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Date: Thu, 20 Dec 2007 19:37:34 +0100
User-Agent: KMail/1.9.7
Cc: Scott <linux-kernel@bluecamel.eml.cc>, linux-kernel@vger.kernel.org
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712200653.28996.volker.armin.hemmann@tu-clausthal.de> <476A7E7E.7030704@davidnewall.com>
In-Reply-To: <476A7E7E.7030704@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712201937.34536.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 20. Dezember 2007, David Newall wrote:
> >>> On Montag, 17. Dezember 2007, you wrote:
> >>>
> >>> and another one, this time tainted with the nvidia module:
> >>> 5194.130985] Unable to handle kernel paging request at 0000030000000000
> >>> RIP:
>
> Numbers like that don't suggest hardware faults.  All those zeros: It's
> far too round.  Sounds very like software.  In fact, it sounds like the
> start of significant hardware region.   And lo! there's a closed-source,
> possibly buggy nvidia module.  Try another; older or newer are equally
> good.

and this one was without the nvidia module:
http://marc.info/?l=linux-kernel&m=119790371708690&w=2

and the first one I reported, was without nvidia and not-tainted too:
http://marc.info/?l=linux-kernel&m=119776365425514&w=2

I am not a complete idiot. If I have a problem, I try to reproduce without 
nvidia first (after a clean shutdown and boot, with the module not even on 
harddisk). And I reproduced it without the module. The last oops with the 
module was just an example that it does not matter if the module is loaded or 
not and to (maybe) give some additional information.

Glück Auf,
Volker
