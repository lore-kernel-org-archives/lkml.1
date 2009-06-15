Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbZFOIpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbZFOIpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZFOIpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:45:06 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:65031 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbZFOIpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kN59rFDF+Ud4LcgrUh+NQ4UlOvFMBCKbIlR+TNhPD56ezdmh9PxQOb85VuweCso6H+
         g9CXgRclT8uS/b7qUMgBdGzjZK5eUsy2hdoVzJvt2sHmk2A7b7Kt6LYRBmC8ENZeoUv9
         gmElMHTEUnVUwr9QARaj74aNkXSAjDeeG8MV8=
MIME-Version: 1.0
In-Reply-To: <412e6f7f0906150107h33b271eam7e610d166967ba70@mail.gmail.com>
References: <412e6f7f0906131829y6e0abb00j85e221f92ab439d2@mail.gmail.com>
	 <20090615071125.GF3544@cr0.nay.redhat.com>
	 <412e6f7f0906150107h33b271eam7e610d166967ba70@mail.gmail.com>
Date: Mon, 15 Jun 2009 16:45:05 +0800
Message-ID: <2375c9f90906150145u1b8e8a1dve794ecbcebb0c548@mail.gmail.com>
Subject: Re: memconsole: a virtual console to record the Oops message for 
	debugging purpose.
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/15 Changli Gao <xiaosuo@gmail.com>:
> On Mon, Jun 15, 2009 at 3:11 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>> On Sun, Jun 14, 2009 at 09:29:48AM +0800, Changli Gao wrote:
>>>
>>>the following code is appended to the file mm/bootmem.c
>>
>>
>> Why not a patch?
>>
>> Your code is a kernel module, why do you append it into
>> a non-module source file?
>>
> bootmem can't be allocated in modules. :(

Ok, then explain your code below:

module_init(init);
...
module_exit(fini);

MODULE_AUTHOR("xiaosuo <xiaosuo@gmail.com>");
MODULE_LICENSE("GPL");
