Return-Path: <linux-kernel-owner+w=401wt.eu-S1751234AbXDLS4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbXDLS4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXDLS4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:56:51 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45621 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbXDLS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:56:50 -0400
X-Sasl-enc: DSN0BLLHVlw5Tv18mi7zCzqhOKBf+G13BcBPb0rlQF0D 1176404210
Date: Thu, 12 Apr 2007 15:56:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Anton Vorontsov <cbou@mail.ru>,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070412185630.GC27804@khazad-dum.debian.net>
References: <20070411232503.GC20095@zarina> <20070412130817.GA29900@srcf.ucam.org> <20070412141505.GA25552@zarina> <20070412142430.GA31240@srcf.ucam.org> <1734853889.20070412173626@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1734853889.20070412173626@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007, Paul Sokolovsky wrote:
>   Yes, that's apparently the way to go. We just should consider
> if mAh and mWh are enough, or we go wider and allow whole collection of
> units. Btw, original handhelds.org code used Joules ;-).

FWIW, SBS only mentions mAh and mWh.  AFAIK, all other (meaningful) units
should be able to be converted to either Ah or Wh, assuming enough precision
on the math.  I never heard of any other way to fuel-gauge batteries than
these two main modes (current-based or capacity-based), but I don't work on
the battery field.

That said, you may need to use uWh and uAh instead of mAh and mWh, though.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
