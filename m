Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbXLIFoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbXLIFoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 00:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXLIFos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 00:44:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:10044 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbXLIFor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 00:44:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ttbIbbkFjTFp8/zsUI2g66OhRX0lqC46QpBJG8zDQdFSd3PsOsBJN8suKgdUBsmpL6DBbjxkuQFBJJErXL9vGw4rXjHi95FvzN7cp8k2LpsQmhOvIbrmtGGhLN+5nCA0sTJpxjnzMYdcILumavI8qUSDumnpJM6Xfm5WP2/D6OE=
Message-ID: <475B80C8.2070102@gmail.com>
Date: Sun, 09 Dec 2007 14:44:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: sam@ravnborg.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       notting@redhat.com, rusty@rustcorp.com.au, kay.sievers@vrfy.org,
       greg@kroah.com
Subject: Re: [PATCH] kbuild: implement modules.order
References: <47555AF1.8090304@gmail.com> <20071207174843.GA20441@stusta.de> <4759DE63.7010206@gmail.com> <20071208142831.GB20441@stusta.de>
In-Reply-To: <20071208142831.GB20441@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> And thinking about it, it doesn't seem to add any problems regarding 
> what I have in mind:
> 
> If we would ever stop having any well-defined link-order for in-kernel 
> code and express everything through initcall levels, we simply must 
> additionally update the modules.order file.

Expressing order in Makefile is a convenient way to express simple
ordering.  I think it's nice to keep it that way even if it doesn't
necessarily mean link order.  So, maybe we can do the reverse and make
built in modules follow module order regardless of actual link order
(say sort init table according to module order before final link).

Thanks.

-- 
tejun
