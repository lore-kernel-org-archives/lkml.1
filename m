Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYKCVMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYKCVMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYKCVMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:12:09 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49803 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYKCVMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:12:08 -0500
X-Sasl-enc: pmCdJZkTWLPs7ME6L/2lHDX2b8+UuJebuqRT6OA7rI9/ 1225746726
Date: Mon, 3 Nov 2008 19:12:00 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx,
       sdhci-devel@list.drzeus.cx
Subject: Re: [patch 6/7] SDHCI: Check DMA for overruns at end of transfer
Message-ID: <20081103211200.GA10721@khazad-dum.debian.net>
References: <20081103200944.099353331@fluff.org.uk> <20081103201010.820070757@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103201010.820070757@fluff.org.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe I didn't understand it right, but if the DMA controller could overrun
a buffer, don't you ALSO need to add defensive padding (i.e. increase the
buffer) to make sure nothing important gets overrun?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
