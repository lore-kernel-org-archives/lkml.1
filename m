Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbXH1Buo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbXH1Buo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 21:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbXH1Buf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 21:50:35 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52736 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbXH1Bue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 21:50:34 -0400
X-Sasl-enc: Bs4OPheK9Q0Fzx1F8Zdd8P1o5KVFAIR+zN+b0BtkUMQF 1188265833
Date: Mon, 27 Aug 2007 22:50:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v1 of IBM power meter driver
Message-ID: <20070828015029.GA10107@khazad-dum.debian.net>
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827211446.GG32667@tree.beaverton.ibm.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Darrick J. Wong wrote:
> documentation doesn't mention any naming conventions for sensors that
> measure Watts, so I am proposing that they be called "powerX_input" in a
> fashion similar to temperature/rpm/current sensors.  If that is
> agreeable to everyone, I'll post a follow-up patch to amend the
> documentation.

What unit should we use? Watts are way, way too big as there is no
floating/fixed point in sysfs.  10^-6 W is probably what is called for,
since we already need 10^-3 V and 10^-3 A.  Small portable devices can
easily draw less than 10^-3 W nowadays.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
