Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbXIGVAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbXIGVAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 17:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758475AbXIGVAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 17:00:34 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39244 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758481AbXIGVAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 17:00:33 -0400
X-Sasl-enc: zfAXG0ScjKaTqJqxgqUbWvlYWGZBhln3Vf9n0ToiRlb1 1189198832
Date: Fri, 7 Sep 2007 18:00:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: David Brownell <david-b@pacbell.net>
Cc: khali@linux-fr.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: Platform device id
Message-ID: <20070907210029.GB4357@khazad-dum.debian.net>
References: <20070907153559.17faf9d1@hyperion.delvare> <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com> <20070907164129.65816B9389@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907164129.65816B9389@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Sep 2007, David Brownell wrote:
> For that matter, a *driver* should never create its own device node(s)
> in the first place.  Device creation belongs elsewhere, like as part of
> platform setup or, for busses with integral enumeration support like
> PCI or USB, bus glue.  Linux is moving away from that legacy model.

This assumes that we have a better bus than "platform" to dump drivers like
thinkpad-acpi, hdaps, and a host of other host-specific stuff.

> I realize that may be more easily said than done in some cases,
> like i8042 on non-PNP systems.

Yes, and there is a LOT of non-PNP stuff involved, since platform became the
dumping ground for host-specific devices (as opposed to platform-specific
devices).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
