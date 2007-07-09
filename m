Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbXGIFPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbXGIFPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 01:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXGIFPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 01:15:23 -0400
Received: from jp1.linux-foundation.org ([207.189.120.31]:36303 "EHLO
	jp1.osdl.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbXGIFPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 01:15:22 -0400
Message-ID: <4691C480.5010600@linux-foundation.jp>
Date: Mon, 09 Jul 2007 14:15:44 +0900
From: "Kunai, Takashi" <kunai@linux-foundation.jp>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: holzheu@linux.vnet.ibm.com
CC: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, gh@us.ibm.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       hpa@zytor.com, joe@perches.com, auke-jan.h.kok@intel.com,
       hansendc@us.ibm.com, davem@davemloft.net, Valdis.Kletnieks@vt.edu,
       kenistoj@us.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: Documentation of kernel messages (Summary)
References: <1181747217.29512.9.camel@localhost.localdomain>	 <20070613111549.db1fa4d9.akpm@linux-foundation.org>	 <1182779321.7142.15.camel@localhost.localdomain>	 <200706251144.48658.rob@landley.net> <1182957079.6643.13.camel@localhost.localdomain>
In-Reply-To: <1182957079.6643.13.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Micheal,

This is a late response to your summary below.

First of all, there is a lot of interest in this issue among Japanese
vendor community. Recently, I have built a Japanese mailing list to
discuss this issue. I'm posting this comment resulting from such discussion.

(1) Your kernel development proposal will be greatly supported by
Japanese vendor community. At the same time, it needs support from the
kernel communities, as well.
(2) As for message ID's, you proposed 3 ways; (a)adding message numbers,
(b)printk hashes and (c)Format strings. (a) seems difficult to get
supports from kernel developers and (c) lacks uniqueness of each
message. Though (b) also lacks uniqueness, adding component id and/or
file name (files name could be hashed, as well), it could achieve some
practical level of uniqueness. To avoid ugly message format, it could be
possible to introduce a system parameter to suppress this hash ids.
Thus, our preference is (b).
(3) As for a documentation file, outside of kernel source tree would be
fine.
(4) When this kernel message scheme become feasible, it will be needed
to talk about the standardized contents of each description
(meanings/actions/etc).

Takashi Kunai
-- 
Kunai, Takashi
The Linux Foundation Japan (New since '07/2/5)
Shibuya Mark City West 22nd Floor
1-12-1 Dogenzaka,Shibuya-ku,Tokyo,Japan
zip150-0043 tel+81-3-4360-5493

Michael Holzheu wrote:
> On Mon, 2007-06-25 at 11:44 -0400, Rob Landley wrote:
>> On Monday 25 June 2007 09:48:41 Michael Holzheu wrote:
>>> Hi all,
>>>
>>> Any idea, how to proceed with this topic? Do you think that any of the
>>> suggested solutions for documentation / translation of kernel messages
>>> will have a chance to be included in the kernel?
>> Personally?  No to the second question, which renders the first "do it 
>> yourself outside of the tree".
> 
> If that is the opinion of the majority here, fine. If there is no hard
> rule on how to define printk macros, one option for us would be to
> define some new s390 specific printk macros for our device drivers.
> Similar to hundreds of other driver specific printk macros in the
> kernel.
> 
>> Just a guess, and I don't speak for anyone else here, but I think most of us 
>> are waiting to see how long it takes you to lose interest.
> 
> :-) Work is not always fun. Sometimes it is just a duty.
> 
> Michael
> 
> 
> 
> 





