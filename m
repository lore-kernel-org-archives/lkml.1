Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbYCXEF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbYCXEF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 00:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYCXEFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 00:05:18 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59965 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbYCXEFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 00:05:16 -0400
X-Sasl-enc: D0F0ELsieuYjKJdkcNXsT58TClScnxu7IEz9SOomNhB1 1206331515
Date: Mon, 24 Mar 2008 01:05:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: your old menuconfig patch series, and select
Message-ID: <20080324040514.GC3321@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

In your menuconfig patch series to convert menu into menuconfig,
you used "if <new menuconfig symbol" quite often.

That causes serious issues with "select".  E.g. currently "select
LEDS_CLASS" does not work, because it is inside a "if NEW_LEDS".

Of course, not much stuff is the target of "select", but classes and
their ilk often are.

What's the best solution for this?  Drop the "if <menuconfig symbol>"
and add lots of "depends on <menuconfig symbol>"?  Or hunt down every
symbol selected inside an if and add the required select for the
menuconfig symbol?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
