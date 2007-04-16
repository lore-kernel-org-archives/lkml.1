Return-Path: <linux-kernel-owner+w=401wt.eu-S1030666AbXDPOeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030666AbXDPOeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030668AbXDPOeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:34:44 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41120 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030666AbXDPOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:34:43 -0400
X-Sasl-enc: TdhhhnEC985UPIrMy4OtS9DUd0tchYV0eKlx0me3qJID 1176734082
Date: Mon, 16 Apr 2007 11:34:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070416143425.GB5695@khazad-dum.debian.net>
References: <20070411232503.GC20095@zarina> <20070415220854.GA20373@localhost.localdomain> <20070415225049.GA27680@zarina> <20070416005722.GA6296@khazad-dum.debian.net> <20070416015705.GA29933@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416015705.GA29933@zarina>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Also, if you your battery can collect and report its approximated values
> > > in additional to momentary values, you're free to add _AVG attributes
> > > to standard ones and use them.
> > 
> > No, that won't help much.  IMO, we want the sanest set of standard
> > attributes we can get, and weird as it might be, average reporting are
> > common properties of battery control firmware on laptops (maybe because of
> > SBS, but still...).
> 
> Why that won't help? Is there something else besides momentary and
> hardware-averaged values?

It wouldn't help much to not have standard generic attributes for the
averaged measurements.

That said, yes, there are relative measurements (percent), and time
measurements (some battery firmware can tell you how much *time* it will
take to stop recharing, empty the battery, etc).

> I guess the only question for you is whether we would use, "attr" as momentary
> and "attr_avg" as averaged by hardware value, or will use "attr" as averaged
> values, and something alike "attr_now" for momentary? And you voting for
> "attr" being averaged and "attr_now" momentary.

I don't care either way, as long as it is *documented* what is averaged, and
what is instantaneous.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
