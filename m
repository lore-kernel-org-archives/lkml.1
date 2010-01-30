Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676Ab0A3SRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0A3SRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443Ab0A3SRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:17:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:29011 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0A3SRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:17:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:cc:subject:references:in-reply-to:x-enigmail-version
         :content-type;
        b=StgUZ9Dqm46tMiq1m8BJs0X/7fyYKbzi+ctX3F1M9m4zQAyPh8yxWcNHkLdx5dx8sn
         Kr/kFYaFOoGeKEh0cdBqds/23/wVdWZHQTc1QnmM6lqY2loJ4I9Qw1sRKYEqs9hcuLzp
         /HGcJHGgrbJug3+sL869e2KGFFLbikH2nAy78=
Message-ID: <4B6477C7.70508@gmail.com>
Date: Sat, 30 Jan 2010 19:17:43 +0100
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
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>	<20100126151202.75bd9347.akpm@linux-foundation.org>	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>	<20100126161952.ee267d1c.akpm@linux-foundation.org>	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>	<20100128001636.2026a6bc@lxorguk.ukuu.org.uk>	<4B622AEE.3080906@gmail.com>	<20100129003547.521a1da9@lxorguk.ukuu.org.uk>	<4B62327F.3010208@gmail.com>	<20100129110321.564cb866@lxorguk.ukuu.org.uk>	<4B64272D.8020509@gmail.com>	<20100130125917.600beb51@lxorguk.ukuu.org.uk>	<4B646CBE.6050404@gmail.com> <20100130174516.2257d7fa@lxorguk.ukuu.org.uk>
In-Reply-To: <20100130174516.2257d7fa@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------050309020409040608090004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050309020409040608090004
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Alan Cox wrote:

>> http://vedranf.net/tmp/oom.ogv  (you can watch it using VLC for example)
>>
>> Actually anyone receiving this mail should see it. What do you think,
>> what will customers rather choose if they see this?
> 
> Address that to the distributions. Their customers. Systems I set up for
> people always have no overcommit enabled.

And distros say that's a bug in kernel. Result: nothing gets done and
users will continue to swear at linux after it kills their work...


-- 
http://vedranf.net | a8e7a7783ca0d460fee090cc584adc12

--------------050309020409040608090004
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
--------------050309020409040608090004--
