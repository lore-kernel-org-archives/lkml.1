Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXGYXxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXGYXxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbXGYXxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:53:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:6327 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbXGYXxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:53:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=KGem5O38ksBJ+F2TEyiDpyMmMNyLp/YVS/JyCOOVwGwByj42rzqGj0uxJPkXUQSE2sR899YAaejEtqliUvv+vOBqgq6ncMY7w/vyoTuZJMtbq8FpwV4QiUqovReni2m6k41NWr8TyJhAUQp1OVgsU6hjL4pRCqunikOthtNV72Q=
Message-ID: <46A7E199.4050906@googlemail.com>
Date: Thu, 26 Jul 2007 01:49:45 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Al Viro <viro@ftp.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: i386 section mismatch warnings
References: <46A5536E.6010606@garzik.org> <20070724014512.GO21668@ftp.linux.org.uk> <46A5AEE0.1070202@googlemail.com> <20070725211550.GB29705@uranus.ravnborg.org>
In-Reply-To: <20070725211550.GB29705@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, Jul 24, 2007 at 09:48:48AM +0200, Gabriel C wrote:
>> Al Viro wrote:
>>> On Mon, Jul 23, 2007 at 09:18:38PM -0400, Jeff Garzik wrote:
>>>> make allmodconfig on i386:
>>>>
>>>> WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to 
>>> Ignore.  vmlinux.o ones are interesting; so are ones in modules.
>>> vmlinux ones are either duplicates of vmlinux.o or false positives.
>> allyesconfig has a lot Section mismatch warnings , are these false positive too ?
>>
>>
>> http://lkml.org/lkml/2007/7/22/312
> 
> Fixed in latest kbuild.git. See the following two patches.
>

One left on vmlinux.o :) and some on vmlinux.

...

WARNING: vmlinux.o(.text+0x183): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')

...

This is on current git head with the 2 patches and allyesconfig. 

 
> 	Sam
> 


Gabriel
