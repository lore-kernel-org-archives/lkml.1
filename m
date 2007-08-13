Return-Path: <linux-kernel-owner+w=401wt.eu-S974661AbXHMTBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S974661AbXHMTBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933568AbXHMTAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:00:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27968 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbXHMTAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:00:52 -0400
Message-ID: <46C0AB7E.9050001@oracle.com>
Date: Mon, 13 Aug 2007 12:05:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       sam@ravnborg.org, zippel@linux-m68k.org, vincent.legoll@gmail.com
Subject: Re: [PATCH] kconfig: update kconfig-language text
References: <20070813113809.9a715e75.randy.dunlap@oracle.com> <20070813185431.GD18945@stusta.de>
In-Reply-To: <20070813185431.GD18945@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Aug 13, 2007 at 11:38:09AM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Add kconfig-language docs for mainmenu, def_bool[ean],
>> and def_tristate.
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
>> ---
>>  Documentation/kbuild/kconfig-language.txt |   12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> --- linux-2.6.23-rc3.orig/Documentation/kbuild/kconfig-language.txt
>> +++ linux-2.6.23-rc3/Documentation/kbuild/kconfig-language.txt
>> @@ -77,6 +77,11 @@ applicable everywhere (see syntax).
>>    Optionally, dependencies only for this default value can be added with
>>    "if".
>>  
>> +- type definition + default value:
>> +	"def_bool"/"def_boolean"/"def_tristate" <expr> ["if" <expr>]
>> ...
> 
> Should the redundant and unused def_boolean be documented or removed?
> 
> I'd prefer the latter.

I don't see a problem with it.  At any rate,
I'm documenting the current state of the source code...

Get it removed and this doc can be changed.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
