Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYJODKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYJODKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 23:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYJODK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 23:10:27 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43015 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbYJODK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 23:10:26 -0400
X-Sasl-enc: x8NRfLhI9MBO9sL5BipTs1s/A5TqsOCnob4LtPh2sxQa 1224040224
Date: Wed, 15 Oct 2008 00:10:18 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 17/18] net/rfkill/rfkill-input.c needs <linux/sched.h>
Message-ID: <20081015031018.GA25190@khazad-dum.debian.net>
References: <20081013195846.674654386@mail.of.borg> <20081013195922.392078574@mail.of.borg> <20081013204559.GC28597@khazad-dum.debian.net> <Pine.LNX.4.64.0810140920320.6220@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810140920320.6220@anakin>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Geert Uytterhoeven wrote:
> Unfortunately that's not possible, due to Include Hell(tm).
> Therefore, including <linux/sched.h> is the way this has been fixed in
> the past.

I see.  Well, when doing this I'd suggest adding a comment, otherwise the
include could end up getting removed sooner or later without anyone asking
linux-m68k first (I seriously douby anyone will do git blame to find out why
an #include line exists before removing it).

Something like:
#include <sched.h> /* m68k needs task_struct for <whatever> */

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
