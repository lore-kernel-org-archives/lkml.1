Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab0APC0q (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758397Ab0APC0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:26:45 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54731 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758296Ab0APC0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:26:45 -0500
X-Sasl-enc: BOZS+J42N2mgbQED66z35ER31hAdaAdRyvQU9ldblPDw 1263608804
Date: Sat, 16 Jan 2010 00:26:41 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - reset inode permissions before
 unlinking
Message-ID: <20100116022641.GF3814@khazad-dum.debian.net>
References: <1263388596.26006.1.camel@yio.site>
 <20100114205304.GC3814@khazad-dum.debian.net>
 <ac3eb2511001141259t751c6063p8919692a8164e2b@mail.gmail.com>
 <20100114210743.GE3814@khazad-dum.debian.net>
 <ac3eb2511001141345w64d42ceckb4d73815298761c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2511001141345w64d42ceckb4d73815298761c2@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Kay Sievers wrote:
> > That said, this does fix a possible security problem when a misconfigured
> > system is used, and the fix looks rather simple...  Can it go to -stable
> > eventually, even if it is months in the future, after it gets some testing
> > in .34 ?   Minor problems are still problems...
> 
> Sure, we could do that. There is some stuff in the current .33 kernel,
> which could go into .32-stable too, if that's useful.

I think it probably would be useful.  I understand .32 is going to stay with
us for a long time, so it should get any fixes that have withstood the test
of time.

It is very annoying to have subtly different kernel behaviour (from
mainline) in a long-term stable series...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
