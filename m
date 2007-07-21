Return-Path: <linux-kernel-owner+w=401wt.eu-S938025AbXGUIkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938025AbXGUIkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933430AbXGUIjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:39:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57926 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701AbXGUIjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:39:41 -0400
Date: Sat, 21 Jul 2007 10:39:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andreas Schwab <schwab@suse.de>
cc: Oleg Verych <olecom@flower.upol.cz>, Sam Ravnborg <sam@ravnborg.org>,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 25/33] kbuild: use POSIX BRE in headers install target
In-Reply-To: <jewswu9ncf.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0707211038150.21737@fbirervta.pbzchgretzou.qr>
References: <11846813423231-git-send-email-sam@ravnborg.org>
 <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org>
 <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org>
 <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org>
 <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org>
 <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-g
 it-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org>
 <11846813 444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org>
 <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org>
 <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org>
 <E1ICAEU-0005an-5F@flower> <jewswu9ncf.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 21 2007 10:23, Andreas Schwab wrote:
>Oleg Verych <olecom@flower.upol.cz> writes:
>
>>> +		-e 
>>> "s/[[:space:]]__user[[:space:]]\{1,\}
>>
>> substitute one or more ' __user '
>
>Substitute ' __user' followed by one or more ' '.  \{\} applies only to
>the last RE atom.

Uhm, would not it be easier to just use 's/\b__user\b//g' ?



	Jan
-- 
