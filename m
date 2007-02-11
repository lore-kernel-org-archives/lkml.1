Return-Path: <linux-kernel-owner+w=401wt.eu-S1750708AbXBKT6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750708AbXBKT6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbXBKT6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:58:52 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54096 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbXBKT6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:58:52 -0500
X-Sasl-enc: fcMjHfRLVwk6ZruiTD+8CUC+X6FurrPepgrKMKezOhsJ 1171223929
Date: Sun, 11 Feb 2007 17:58:46 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libsata doesn't like bus without master
Message-ID: <20070211195846.GC26874@khazad-dum.debian.net>
References: <fa.OcrmlkSFqen95BGHXWJdR6KGswQ@ifi.uio.no> <fa.mIV6AQH7D5yiY39XNxbu0M2/1Kc@ifi.uio.no> <fa.3Ti1gtH2JY4DWsqr3J1loC7lcc0@ifi.uio.no> <45CF619D.6000704@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CF619D.6000704@shaw.ca>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007, Robert Hancock wrote:
> Then in that case you should set the remaining drive as master. That's 
> just the way PATA is. A lot of BIOSes won't even detect a drive that's 
> set as slave with no master present.

I have seen at least three *thousand* boxes configured that way in the last
five years.  From at least a hundred different vendors (almost all of them
small "system assembler" vendors that mix generic and customer-specified
parts).

For some stupid reason, it appears that the norm around here (Brazil) is
that "no brand" boxes get assembled with ATAPI devices in slave mode.
Usually they attach it to the second channel using an 40-wire cable, even if
there is nothing using the first channel.

There is an amazing ammount of hardware out there which needs PATA drivers
to deal as gracefully as possible on a ATAPI PATA device alone as slave on a
channel, and I'd say at that point it is best to just deal with ATA PATA
devices in that configuration, too.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
