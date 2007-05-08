Return-Path: <linux-kernel-owner+w=401wt.eu-S934723AbXEHWUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbXEHWUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934658AbXEHWT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:19:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53043 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934585AbXEHWT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:19:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4640F76A.9070707@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 00:19:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, bunk@stusta.de, cornelia.huck@de.ibm.com,
       greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11 (PCI_MULTITHREAD_PROBE)
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>	<20070508141149.GJ4226@stusta.de>	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org> <20070508.141554.112287211.davem@davemloft.net>
In-Reply-To: <20070508.141554.112287211.davem@davemloft.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
[persistent unique device property -> persistent unique device name]
> Those mappings should exist statically somewhere, not depend upon
> something as frivolous as probe ordering.

We do this all the time for hotpluggable hardware.  And bus types
without hotplugging capability become increasingly rare nowadays. :-)
-- 
Stefan Richter
-=====-=-=== -=-= -=---
http://arcgraph.de/sr/
