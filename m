Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbXFAQ2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbXFAQ2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbXFAQ22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:28:28 -0400
Received: from relay4.usu.ru ([194.226.235.39]:33552 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbXFAQ21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:28:27 -0400
Message-ID: <46604928.4050002@ums.usu.ru>
Date: Fri, 01 Jun 2007 22:28:24 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>, lkml@dervishd.net
Subject: Re: Kernel utf-8 handling
References: <20070601142058.GA2587@DervishD>
In-Reply-To: <20070601142058.GA2587@DervishD>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DervishD wrote:
>     Hi all :)
> 
>     I have a do-it-yourself Linux box, and I'm planning to move to UTF8
> (currently I'm using es_ES locale, with latin1 encoding). One of my main
> concerns (apart from programs with little or no utf8 support, which I
> will have to suffer) is kernel handling, because I only use the console;
> I only use X and a terminal emulator if I can't avoid it.

The switch is possible. You could try the latest development LFS LiveCD 
(http://ums.usu.ru/~patrakov/test/lfslivecd-x86-6.3-pre2-r1897.iso) and see 
if it works for you (be sure to CC: me if you post any feedback). It will 
automatically configure the console using a simple menu-driven interface. 
Some interesting programs to try there: mutt, tin, lynx, finch.

>     This said, I know that the console will give me no problems
> regarding character representantion (heck, I'm pretty sure that I will
> be able to use even the same font I'm using right now in the console if
> I get the proper unicode map), but probably will give me problems when
> *entering* characters. I've read that the kernel handles accented chars,
> and things like 'ñ' (ntilde) because it assumes that any composed
> character (composed using dead keys, for example) is in the latin1
> range. While this is not a perfect behaviour, it will work for me.

Yes.

>     Will the console work as it works now if I can live with latin1
> accented characters only? Is there any terminal emulator *for the
> console*, not for X, that handles utf8? Will I be sentenced to X to be
> able to use my computer with utf8?

screen, jfbterm, iterm (jfbterm and iterm are not on my CD, but you can 
build them from source there - the filesystem on the CD can be written to). 
Note that jfbterm and iterm expect X fonts (or unifont) to be available, and 
the CD doesn't have these fonts (fully switched to Xft).

-- 
Alexander E. Patrakov
