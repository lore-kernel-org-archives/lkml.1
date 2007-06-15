Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbXFOFJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbXFOFJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 01:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbXFOFJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 01:09:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:33958 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbXFOFJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 01:09:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,422,1175497200"; 
   d="scan'208";a="239414230"
Message-ID: <46721F18.8090303@intel.com>
Date: Thu, 14 Jun 2007 22:09:44 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: coding style
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu>
In-Reply-To: <20070615045111.GU943@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Thu, Jun 14, 2007 at 10:48:36PM +0400, Cyrill Gorcunov wrote:
>> Hi to all,
>>
>> a simple question the answer to witch I didn't find in CodingStyle.
>> Look for a code snip:
>>
>> 	err = foo(arg_a, arg_b, arg_c,
>> 		arg_d);
>>
>> the second line contains 'd' arg aligned with tabs only
>> but it could be rewritten with more elegant style (by adding
>> a few spaces) like this
>>
>> 	err = foo(arg_a, arg_b, arg_c,
>> 		  arg_d);
>>
>> so which one is preferred for the kernel?
> 
> There is no "preferred", just one good and one bad :-)
> 
> Ideally, you should use tabs only for indentation, and spaces only for
> alignment. Keep in mind that there are people using different tab sizes
> and that your tabs should not make it harder for them to read your code.
> In your example above, you should use tabs from left up to "err", then
> spaces to go from "err" to "arg_d".
> 
> However, we know that some editors such as emacs are stupid in this regard,
> because they fill with tabs then complete with spaces, so it's not always
> easy.

the current "checkpatch.pl" script rejects this notion and requires that you use 
tabs whenever you can (you can still align code within the length of one tab).

Since in the example part (2) above there are 9 spaces needed to go from err to 
arg_d, it complains if you had used 9 spaces here. It only allows you to use 
tabs + n spaces (where n < 8)

I personally prefer spaces, but the checkpatch.pl script does not agree, much to 
my dismay :(


Auke
