Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYJFCQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYJFCQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 22:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYJFCQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 22:16:18 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45070 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbYJFCQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 22:16:17 -0400
X-Sasl-enc: M3NGsSSKnq25UC+Rix36NqfVWooGZwWh5BxZhtqNbHCJ 1223259375
Date: Sun, 5 Oct 2008 23:16:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, dmitry.torokhov@gmail.com,
       sitsofe@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rfkill-input doesn't work until 5 minutes after boot
Message-ID: <20081006021608.GA27364@khazad-dum.debian.net>
References: <20081004204342.GA29620@srcf.ucam.org> <20081005004334.GA31844@srcf.ucam.org> <20081005110226.GB4087@srcf.ucam.org> <200810051631.03844.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810051631.03844.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Oct 2008, Ivo van Doorn wrote:
> I am not too happy about the multiple jiffies - HZ/5 statements
> regardless of the comment that it should be updated when new tasks are
> defined.
> 
> But on the other hand I haven't seen any real alternatives yet either,
> so I have no objections against this patch either.

It doesn't matter much.  The next rfkill patchset will remove most of that
code, anyway (and yes, I *will* make sure it doesn't have the same issue
this patch is fixing).  But that's 2.6.28/2.6.29 stuff, probably 2.6.29.

I didn't send them yet because I was still changing other parts of the code
too much.  I may send them soon as RFC.

In other words, don't worry too much about that maintenance annoyance in
rfkill-input.  It will not be around for long.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
