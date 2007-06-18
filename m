Return-Path: <linux-kernel-owner+w=401wt.eu-S1763659AbXFROnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763659AbXFROnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760717AbXFROnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:43:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23314 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431AbXFROnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:43:31 -0400
Message-ID: <46769A22.3030908@oracle.com>
Date: Mon, 18 Jun 2007 07:43:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] blink: Only blink when parameter is set
References: <20070617083904.GC4496@suse.de> <20070617212601.38f952fe.randy.dunlap@oracle.com> <20070618071819.GA9953@suse.de>
In-Reply-To: <20070618071819.GA9953@suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> [2007-06-18 06:26]:
>>> +static int blink = 0;
>> no need to init to 0.
> 
> Does it harm?

It adds space to the binary file in some cases and it is kernel
convention not to init statics to NULL or 0 since that is already
guaranteed for them.

>>> +module_param(blink, bool, S_IRUGO);
>>> +MODULE_PARM_DESC(blink, "Enable blinking (without that, the module does nothing)\n");
>> unneeded "\n"
> 
> Fixed. Please use the following patch.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
