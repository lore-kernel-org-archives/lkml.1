Return-Path: <linux-kernel-owner+w=401wt.eu-S932756AbXGVMrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbXGVMrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759632AbXGVMrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:47:43 -0400
Received: from il.qumranet.com ([82.166.9.18]:55752 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbXGVMrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:47:43 -0400
Message-ID: <46A351F7.30601@qumranet.com>
Date: Sun, 22 Jul 2007 15:47:51 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yaniv Kamay <yaniv@qumranet.com>
Subject: Re: drivers/kvm/x86_emulate.c - address of 'twobyte_table' will always
 evaluate as 'true' , warning
References: <46A35002.1010705@googlemail.com>
In-Reply-To: <46A35002.1010705@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi,
>
> I got this warning on current git with gcc 4.2.1 :
>
> ...
>
> drivers/kvm/x86_emulate.c: In function 'x86_emulate_memop':
> drivers/kvm/x86_emulate.c:817: warning: the address of 'twobyte_table' will always evaluate as 'true'
>
> ...
>   

Thanks!  That's a real bug (though harmless at present).  Will fix it up.

-- 
error compiling committee.c: too many arguments to function

