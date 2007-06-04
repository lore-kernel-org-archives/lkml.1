Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbXFDSFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbXFDSFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759656AbXFDSE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:04:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:37571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758414AbXFDSEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:04:55 -0400
From: Andi Kleen <ak@suse.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Date: Mon, 4 Jun 2007 20:04:34 +0200
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070604112426.GA2707@elf.ucw.cz> <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com> <20070604163406.GA1120@khazad-dum.debian.net>
In-Reply-To: <20070604163406.GA1120@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706042004.35062.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 18:34, Henrique de Moraes Holschuh wrote:

> And DoS'ing the EC is very high on the Don't Do That list on a laptop.  If
> the X60 is only losing keypresses and producing no bigger fireworks, that's
> outstanding behavior (as far as I trust ThinkPad firmware, anyway).
>
> So please throttle anything that might access the KDC way too much (as
> compared to normal keyboard operation by an user).

The io port accesses are already throttled and the blinking are quite slow in 
computer time (talking about hundreds of milliseconds). It is hard to imagine
the EC is that slow.

-Andi
