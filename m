Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXG0Te1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXG0Te1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762571AbXG0TeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:34:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33174 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762146AbXG0TeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:34:17 -0400
Date: Fri, 27 Jul 2007 21:34:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chris Friesen <cfriesen@nortel.com>
cc: Subbu Seetharaman <subbus@serverengines.com>, linux-kernel@vger.kernel.org
Subject: Re: Source organization for two drivers sharing coomon code
In-Reply-To: <46AA4395.3050907@nortel.com>
Message-ID: <Pine.LNX.4.64.0707272131270.16356@fbirervta.pbzchgretzou.qr>
References: <20070727171729.f3ff0878@mailhost.serverengines.com>
 <Pine.LNX.4.64.0707272102070.16356@fbirervta.pbzchgretzou.qr>
 <46AA4395.3050907@nortel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 27 2007 13:12, Chris Friesen wrote:
> Jan Engelhardt wrote:
>> On Jul 27 2007 10:17, Subbu Seetharaman wrote:
>> 
>> >What is the recommended way for two drivers to share common code ?
>> ><snip>...The source code for these dirvers will fit under drivers/net and
>> >drivers/scsi.  But both drivers share some common code.
>
>> You could create (in total) three modules, e.g. my-common.ko,
>> my-net.ko and my-scsi.ko, of which the latter two use functions from the
>> first.
>
> Where would the common code live, in such a case?  Would you just pick one of
> the two locations at random, or put it in drivers/misc or maybe lib?

Perhaps drivers/message - well I can't answer that exactly.

As far as the output object files are concerned, it is not relevant,
since they will be autoloaded anyway :)



	Jan
-- 
