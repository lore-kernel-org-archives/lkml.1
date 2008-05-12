Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYELU3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYELU3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbYELU3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:29:46 -0400
Received: from bar.sig21.net ([88.198.146.85]:33174 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbYELU3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:29:45 -0400
X-Greylist: delayed 2621 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 16:29:45 EDT
Date: Mon, 12 May 2008 21:46:30 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump
	firmware build error fix
Message-ID: <20080512194630.GA10174@linuxtv.org>
References: <20080512101231.GA11755@elte.hu> <200805121930.10909@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805121930.10909@orion.escape-edv.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.601,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 07:30:10PM +0200, Oliver Endriss wrote:
> Ingo Molnar wrote:
>> -     depends on DVB_AV7110 && !STANDALONE
>> +     depends on DVB_AV7110 && !STANDALONE && !PREVENT_FIRMWARE_BUILD

> If you set DVB_AV7110_FIRMWARE=y, the firmware file under
> DVB_AV7110_FIRMWARE_FILE must exist...

The point of PREVENT_FIRMWARE_BUILD is to make build testing
with "make randconfig" possible. I think you should ACK
this patch, it doesn't have any downsides for users of
this driver.

Johannes
