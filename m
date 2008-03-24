Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYCXGyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYCXGyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 02:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYCXGyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 02:54:40 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53012 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494AbYCXGyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 02:54:39 -0400
X-Sasl-enc: wBJ4tSLBxx1IS89a1qy5ELYB0OTOMGBG/inYbMaYL5cW 1206341678
Date: Mon, 24 Mar 2008 03:54:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: your old menuconfig patch series, and select
Message-ID: <20080324065436.GA24085@khazad-dum.debian.net>
References: <20080324040514.GC3321@khazad-dum.debian.net> <alpine.LNX.1.10.0803240542030.27005@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0803240542030.27005@fbirervta.pbzchgretzou.qr>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008, Jan Engelhardt wrote:
> It "does not work" either if LEDS_CLASS is put outside of the if block
> and instead gets a "depends on LEDS_CLASS".

So, select is not walking the dep chain.  Bad form, that, but I am sure
it is for a good reason.  Well, select NEW_LEDS plus select LED_CLASS it
is, then.  I'd have appreciated the Kconfig toolchain warning me of it,
but maybe I just don't know how to ask it to :-)

Thanks for the fast reply.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
