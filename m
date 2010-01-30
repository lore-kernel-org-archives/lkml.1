Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014Ab0A3MrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab0A3MrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 07:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517Ab0A3MrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 07:47:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:49715 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0A3MrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 07:47:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:cc:subject:references:in-reply-to:x-enigmail-version
         :content-type;
        b=j60l8mIjjzv5aUB6yGUp+l3n5qpy+EdCjKifaEGB3XsSsElIzHGMovs0+jZ/odYyyL
         dhsFxUjMtrAoQwy74mDZwRLrArMabFnBeyqUHq3B/EOEa9dvHVR+OPOU7fRXCaQ9qD92
         f6nFkVm4GxD+L+CKyKonwuLzwMhRJSCI4R47Y=
Message-ID: <4B642A40.1020709@gmail.com>
Date: Sat, 30 Jan 2010 13:46:56 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20091109 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
References: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com> <20100129162137.79b2a6d4@lxorguk.ukuu.org.uk> <c6c48fdf7f746add49bb9cc058b513ae.squirrel@webmail-b.css.fujitsu.com> <20100129163030.1109ce78@lxorguk.ukuu.org.uk> <5a0e6098f900aa36993b2b7f2320f927.squirrel@webmail-b.css.fujitsu.com> <alpine.DEB.2.00.1001291258490.2938@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001291258490.2938@chino.kir.corp.google.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------020707070908060404060701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020707070908060404060701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

David Rientjes wrote:

> The oom killer has been doing this for years and I haven't noticed a huge 
> surge in complaints about it killing X specifically because of that code 
> in oom_kill_process().

Well you said it yourself, you won't see a surge because "oom killer has
been doing this *for years*". So you'll have a more/less constant number
of complains over the years. Just google for: linux, random, kill, memory;

What provoked me to start this discussions is that every few months on
our croatian linux newsgroup someone starts asking why is linux randomly
killing his processes. And at the end of discussion a few, mostly
aix/solaris sysadmins, conclude that linux is still a toy.

Regards,
Vedran

-- 
http://vedranf.net | a8e7a7783ca0d460fee090cc584adc12

--------------020707070908060404060701
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
--------------020707070908060404060701--
