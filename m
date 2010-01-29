Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117Ab0A2A5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0A2A5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710Ab0A2A5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:57:39 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:33246 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab0A2A5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:57:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:cc:subject:references:in-reply-to:x-enigmail-version
         :content-type;
        b=QUnVWITdTSmtyj4b8genUHofR34n13Kab8rWDbDfXS2013t1kZkabIEAdlt/PDAJv/
         lAChHrt5k2oMVkN0fDTbazK2zVRbln1+aL9HQdIg8U+9WV12HjI2rW0keDb8ntJ4gKHr
         L5IO3+cTs21HrvRna6jLDeU6lkNBRfGhkTc8w=
Message-ID: <4B62327F.3010208@gmail.com>
Date: Fri, 29 Jan 2010 01:57:35 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20091109 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>	<20100126151202.75bd9347.akpm@linux-foundation.org>	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>	<20100126161952.ee267d1c.akpm@linux-foundation.org>	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>	<20100128001636.2026a6bc@lxorguk.ukuu.org.uk>	<4B622AEE.3080906@gmail.com> <20100129003547.521a1da9@lxorguk.ukuu.org.uk>
In-Reply-To: <20100129003547.521a1da9@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------090706020006080103030803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090706020006080103030803
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Alan Cox wrote:

> On Fri, 29 Jan 2010 01:25:18 +0100
> Vedran Furač <vedran.furac@gmail.com> wrote:
> 
>> Alan Cox wrote:
>>
>>> Am I missing something fundamental here ?
>> Yes, the fact linux mm currently sucks. How else would you explain
>> possibility of killing random (often root owned) processes using a 5
>> lines program started by an ordinary user? 
> 
> If you don't want to run with overcommit you turn it off. At that point
> processes get memory allocations refused if they can overrun the

I've started this discussion with question why overcommit isn't turned
off by default. Problem is that it breaks java and some other stuff that
allocates much more memory than it needs. Very quickly Committed_AS hits
CommitLimit and one cannot allocate any more while there is plenty of
memory still unused.

> theoretical limit, but you generally need more swap (it's one of the
> reasons why things like BSD historically have a '3 * memory' rule).

Say I have 8GB of memory and there's always some free, why would I need
swap?

> So sounds to me like a problem between the keyboard and screen (coupled

Unfortunately it is not. Give me ssh access to your computer (leave
overcommit on) and I'll kill your X with anything running on it.


-- 
http://vedranf.net | a8e7a7783ca0d460fee090cc584adc12

--------------090706020006080103030803
Content-Type: text/x-vcard; charset=utf-8;
 name="vedran_furac.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="vedran_furac.vcf"

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6VmVkcmFuIEZ1cmE9QzQ9OEQNCm47
cXVvdGVkLXByaW50YWJsZTpGdXJhPUM0PThEO1ZlZHJhbg0KYWRyOjs7Ozs7O0Nyb2F0aWEN
CmVtYWlsO2ludGVybmV0OnZlZHJhbi5mdXJhY0BnbWFpbC5jb20NCngtbW96aWxsYS1odG1s
OkZBTFNFDQp1cmw6aHR0cDovL3ZlZHJhbmYubmV0DQp2ZXJzaW9uOjIuMQ0KZW5kOnZjYXJk
DQoNCg==
--------------090706020006080103030803--
