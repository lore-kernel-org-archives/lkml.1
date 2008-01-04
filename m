Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYADNXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYADNXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYADNXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:23:34 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:47105 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYADNXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:23:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QBm3sDKGVXziGzLpzM4RqY75SvJapipJZ0wYE2lN8eeXdLti6PPWtL8IXLFvDxe4z2rY9GVIMXfU5D/kchSfJVZnzlIc+r9Go81IK6Bkuji6GmehG/50Bl5mGdnfKf1Tzxnhz9CRC6SdrqTL0tjuHrbSEML+7vKIQkxXJ6XZz9A=
Date: Fri, 4 Jan 2008 21:23:16 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild update
Message-ID: <20080104132316.GA2485@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080103213255.GA21811@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103213255.GA21811@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


{snip}

>TODO items (from my mailbox - I have plenty more)
>=================================================
>- asm-offset useable from modules (Oleg had a half backed solution)
>- modpost should use err(), warn() etc (suggestyed by Rusty)
>- less kernel hardcoding in kconfig (Rob Landley)
>- emit dependencies from "depends" (Bernhard Fischer)
>- fix select (whatever that means)
>- allow kconfig to accept overrides (Jan Engelhart)
>  maybe there is a patch, needs followup
>- document kernel build better (Andreas Hermann)
>  just a start, more is needed
>- save ARCH and CROSSCOMPILE
>  requires major surgery to do correct - we use CC too early
>- i18n patch for mconf and friends (from Kernel Translator project)
>  is old but several bits of it needs to be applied to better support i18n

Hmm, I glanced at that project. It's old and seems freezed now.
I don't know if people still have interests in the i18n of kconfig.
If so, I think I can help with the Chinese part. ;)


>- i18n support in kernel
>  some like it, others don't. But now we have japanese versions of some docs...

Well, in fact, we've already had some Chinese docs too. ;)
Just have a look at Documentation/zh_CN/.


>- use GCC --combine (David Woodhouse)
>- more color themes (Jan Engelhart)
>  and I would like them selectable from inside menuconfig
>- walk throug the ~15 qconf related patched - are they relevant?
>- document use of __init and related sections
>- Use seperate sections for all init sections to improve checking
>- improve headers_check (10x speed up is possible by doing a dir-by-dir check)
>
>bugzilla.kernel.org
>===================
>7103 	sam@ravnborg.org 	NEW 		2.6.17.* 	initramfs problem
>3174 	sam@ravnborg.org 	ASSI 		2.6.7 	        make rpm creates erroneous version number
>3486 	sam@ravnborg.org 	ASSI 		2.6.4-52 	"make clean" on external driver will clean the kernel sou...
>6860 	sam@ravnborg.org 	ASSI 		2.6.18-rc1 	'make deb-pkg' create incorrect package name
>7042 	sam@ravnborg.org 	ASSI 		2.6.17.7 	Recursing into /lib/modules/`uname -r`/build infects my b...
>8275 	sam@ravnborg.org 	ASSI 		2.6.21-rc5-g28d... 	make rpm-pkg broken for git cloned sources
>

I will take a look at the problems and see if I can help you.

{snip}

>Note: The kbuild stuff is done only in my spare time and
>      with 3 kids, a wife and a full-time job I am often lacking behind.

Thanks for your work, Sam!

