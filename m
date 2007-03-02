Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXCBVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXCBVEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965627AbXCBVEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:04:46 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50895 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965626AbXCBVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:04:45 -0500
X-Sasl-enc: tAkjIIOD+YcQ3WjCEE00fOQxAP5yeK9s/sw3xH5uJruH 1172869485
Date: Fri, 2 Mar 2007 18:04:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marko Rauhamaa <marko@pacujo.net>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Is the clockevent resolution fine-grained enough?
Message-ID: <20070302210440.GB11786@khazad-dum.debian.net>
References: <m3649kweyj.fsf@elektro.pacujo.net> <1172851546.24738.62.camel@localhost.localdomain> <m3k5xzy2w3.fsf@elektro.pacujo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3k5xzy2w3.fsf@elektro.pacujo.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007, Marko Rauhamaa wrote:
> I'm afraid you didn't quite understand what I was getting at. Say the
> user programs the frequency to be 109,000 Hz. That means a nominal clock
> interval of ~9174.3119 ns. Now the clockevent interface forces me to
> round it down to 9174 ns. That means the clock interrupts fall behind
> with respect to the other parts in the system that implement 109,000 Hz
> much more to the letter. The error grows by 34 µs every second so that
> after 8 hours, we are lagging by a whole second.

Shouldn't you switch to a design where these errors become jitter instead of
cumulative?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
