Return-Path: <linux-kernel-owner+w=401wt.eu-S967671AbXHMShH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967671AbXHMShH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762343AbXHMSOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:14:12 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:56690 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032781AbXHMSOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:14:07 -0400
Message-ID: <46C09E87.1030001@gmail.com>
Date: Mon, 13 Aug 2007 20:10:15 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, Joe Perches <joe@perches.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -	scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>	 <200708131933.10125.m.kozlowski@tuxland.pl> <1187026955.2688.4.camel@laptopd505.fenrus.org>
In-Reply-To: <1187026955.2688.4.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2007 07:42 PM, Arjan van de Ven wrote:

> On Mon, 2007-08-13 at 19:33 +0200, Mariusz Kozlowski wrote:
>> Hello,
>>
>> 	I don't recall discusion about this so here are my 3 cents:
>>
>> 	I like the idea. 
> 
> I don't actually. It shows a central MAINTAINERS file is the wrong
> approach; just that 500+ patches to the same file were needed shows
> that. 

Quite.

> The maintainer info should be in the source file itself! That's the only 
> reasonable way to keep it updated; now I'm all for having it machine 
> parsable so that tools can use it, but it still really should be in the 
> code itself, not in some central file that will always just go out of 
> data, and will be a huge source of needless patch conflicts.

This is quite like the OO-INDEX discussion now going, where I saw it argued 
that the one-line summaries could go at the top of the actual Documentation 
files themselves, where they could be mechanically extracted to _build_ the 
index files. Keeping things in sync is the important reason there as well.

While the notion behing these patches appears to be good, the tree sees many 
changes through addition, removal and movement of files which affects this. 
Is Linus's copy of git going to check if an added file doesn't overlap with 
an existing wildcard in the MAINTAINERS file and delele or adjust wildcards 
upon removal or movement?

I personally think it wouldn't be such as bad idea to introduce a standard 
Linux source file header, with (when present) information such as the 
summary for index files, maintainer information, and other information now 
present in MAINTAINERS. With it being in the sourcefile themslves, it will 
stand a much better chance of staying up to date.

Rene.
