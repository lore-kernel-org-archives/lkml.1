Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbXFAOTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbXFAOTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbXFAOSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:18:53 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:50732 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758096AbXFAOSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:18:53 -0400
Date: Fri, 1 Jun 2007 16:20:58 +0200
From: DervishD <lkml@dervishd.net>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Kernel utf-8 handling
Message-ID: <20070601142058.GA2587@DervishD>
Mail-Followup-To: Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :)

    I have a do-it-yourself Linux box, and I'm planning to move to UTF8
(currently I'm using es_ES locale, with latin1 encoding). One of my main
concerns (apart from programs with little or no utf8 support, which I
will have to suffer) is kernel handling, because I only use the console;
I only use X and a terminal emulator if I can't avoid it.

    This said, I know that the console will give me no problems
regarding character representantion (heck, I'm pretty sure that I will
be able to use even the same font I'm using right now in the console if
I get the proper unicode map), but probably will give me problems when
*entering* characters. I've read that the kernel handles accented chars,
and things like 'ñ' (ntilde) because it assumes that any composed
character (composed using dead keys, for example) is in the latin1
range. While this is not a perfect behaviour, it will work for me.

    Will the console work as it works now if I can live with latin1
accented characters only? Is there any terminal emulator *for the
console*, not for X, that handles utf8? Will I be sentenced to X to be
able to use my computer with utf8?

    Don't take me bad, I really would love to spend 100MiB of RAM just
to run mutt under xterm, but for the time being I prefer the console to
work even if I must run X...

    Thanks a lot! :))

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
