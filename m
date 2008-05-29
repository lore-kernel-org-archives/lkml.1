Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYE2Q0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYE2Q0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYE2Q03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:26:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47784 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbYE2Q02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:26:28 -0400
X-Sasl-enc: +enocVSJz/sgO019eB1FWT9c3C2Uzy/JKiOp76KyS6NS 1212078386
Date: Thu, 29 May 2008 13:26:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify
	input subsystem interactions (v2)
Message-ID: <20080529162625.GA3375@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <20080521014458.GB26427@khazad-dum.debian.net> <20080529004555.GA3872@khazad-dum.debian.net> <200805291502.23726.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805291502.23726.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Ivo van Doorn wrote:
> > This version better documents *_RFKILL_ALL.  Is it good enough for an
> > ACK for patch 14 of 15?
> 
> Yes, you can put my ack on patch 14.
> Thanks for the documentation update. :)

Then, this entire batch is ready for merging.  Now, if only Len would
come back from wherever he disappeared to, in order to merge the two
thinkpad-acpi patches, I could send it to netdev for merge.

I will at least publish the entire stack as a thinkpad-acpi pre-release
version, to get some testing on the real world with some power users.

I am thinking about how to best handle the global states.  Doing it
through the rfkill class is ready, but the result was *UGLY*.  More on
this later.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
