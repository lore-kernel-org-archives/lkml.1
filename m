Return-Path: <linux-kernel-owner+w=401wt.eu-S1765055AbXG0TNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765055AbXG0TNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbXG0TM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:12:59 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:38989 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760975AbXG0TM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:12:59 -0400
Message-ID: <46AA4395.3050907@nortel.com>
Date: Fri, 27 Jul 2007 13:12:21 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Subbu Seetharaman <subbus@serverengines.com>, linux-kernel@vger.kernel.org
Subject: Re: Source organization for two drivers sharing coomon code
References: <20070727171729.f3ff0878@mailhost.serverengines.com> <Pine.LNX.4.64.0707272102070.16356@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707272102070.16356@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2007 19:12:25.0541 (UTC) FILETIME=[11267F50:01C7D082]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 27 2007 10:17, Subbu Seetharaman wrote:
> 
>>What is the recommended way for two drivers to share common code ?
>><snip>...The source code for these dirvers will fit under 
>>drivers/net and drivers/scsi.  But both drivers share some common 
>>code.

> You could create (in total) three modules, e.g. my-common.ko,
> my-net.ko and my-scsi.ko, of which the latter two use functions from the first.

Where would the common code live, in such a case?  Would you just pick 
one of the two locations at random, or put it in drivers/misc or maybe lib?

Chris
