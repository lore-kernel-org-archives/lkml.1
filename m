Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbZCOWGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbZCOWGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 18:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZCOWGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 18:06:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:58522 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754101AbZCOWGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 18:06:37 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX18+yrQmUZw+ciKCA/Fo+vfsj4Me4ISwrDzD6DAYVZ
	OVLoc2n+OrbLpN
Message-ID: <49BD7BEA.50307@fisher-privat.net>
Date: Sun, 15 Mar 2009 23:06:34 +0100
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: smart cache. ist is possible?
References: <49BD1EB7.6080109@fisher-privat.net> <20090315181315.GA4369@silver.sucs.org>
In-Reply-To: <20090315181315.GA4369@silver.sucs.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sitsofe Wheeler schrieb:
> Hi,
> 
> On Sun, Mar 15, 2009 at 04:28:55PM +0100, Alexey Fisher wrote:
>> I found for my self how great is cache in linux. If read one file from
>> disk, so i don't need to do it second time, chace will do the job. It
>> speed up thing greatly. But i found it not working with realy big files.
>> Like i have 4GB RAM, so if i read a file like 4.6GB, cache won't work.
> 
> Watch out - if you are doing cache tests you really want to be using
> drop_caches ( http://linux-mm.org/Drop_Caches ) before your "cold" runs
> so you can be sure that the cache really was empty before you started...
> 

It is not what i mean. I know how to clear cache but exactly i do not 
won't it. I will use cache and it's working perfectly with small files. 
But there is a problem with big files. For example i have 4GB RAM, if i 
read 4,6GB file the cache is useless. The question is; are there any way 
to workaround it, except more RAM?
