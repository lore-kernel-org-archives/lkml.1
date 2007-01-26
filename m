Return-Path: <linux-kernel-owner+w=401wt.eu-S1030664AbXAZAOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664AbXAZAOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030665AbXAZAOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:14:51 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40299 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030664AbXAZAOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:14:49 -0500
X-Sasl-enc: 84VRY7S52l13+A4H7Ubwl2CIUathGbLO1/GDq5U7rnG7 1169770488
Date: Thu, 25 Jan 2007 22:14:41 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [discuss] portmapping sucks
Message-ID: <20070126001441.GE2206@khazad-dum.debian.net>
References: <Pine.LNX.4.61.0701250030530.32656@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701250030530.32656@yvahk01.tjqt.qr>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007, Jan Engelhardt wrote:
> As we all know, mountd and other SUNRPC (I question this invention too) 
> services are at a fixed RPC port number (/etc/rpc) which are mapped 
> to a random TCP/UDP port, and the application doing the mappings is
> portmap. This random TCP/UDP port selection is what makes it suck.

1. This is OT here.
2. See "portreserve" in Debian for a possible solution (that nobody in
Debian paid any attention to, so it never reserves anything :p).  Other
distros (RedHat/Fedora?) might have it too.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
