Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0CCSAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:00:48 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:44402 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab0CCSAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:00:46 -0500
From: James Cloos <cloos@jhcloos.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, geert@linux-m68k.org, elendil@planet.nl
Subject: Re: [PATCH] kconfig: place git SHA1 in .config output if in SCM
In-Reply-To: <20100303021624.GE6786@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Tue, 2 Mar 2010 18:16:24 -0800")
References: <20100303011858.GA17651@linux.vnet.ibm.com>
	<alpine.LFD.2.00.1003021725170.3616@localhost.localdomain>
	<20100303021624.GE6786@linux.vnet.ibm.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Wed, 03 Mar 2010 12:28:38 -0500
Message-ID: <m37hptl3fl.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:30:100303:paulmck@linux.vnet.ibm.com::PHWuCj6J+PzoWOgj:0000000000000000000000000000000000CIPYj
X-Hashcash: 1:30:100303:torvalds@linux-foundation.org::iL8LDWclN//yu0Aj:0000000000000000000000000000000p0h61
X-Hashcash: 1:30:100303:linux-kernel@vger.kernel.org::BET//MYeh2vJtN4t:00000000000000000000000000000000ZdjV+
X-Hashcash: 1:30:100303:zippel@linux-m68k.org::/j0DYBO+UxwX9NNC:000000000000000000000000000000000000000iMdE0
X-Hashcash: 1:30:100303:mingo@elte.hu::pORFu6WLZz9ypeQS:000rBPvJ
X-Hashcash: 1:30:100303:akpm@linux-foundation.org::IV+ZaQim5g7dznnv:00000000000000000000000000000000000eb4OX
X-Hashcash: 1:30:100303:geert@linux-m68k.org::V/rssOvD6UdbKIow:0000000000000000000000000000000000000000D9xwt
X-Hashcash: 1:30:100303:elendil@planet.nl::aejh3+vQrej8TM0L:0000000000000000000000000000000000000000000NN3ct
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doesn't this patch simply duplicate CONFIG_LOCALVERSION_AUTO's
functionality, now that it calls scripts/setlocalversion?

I'd still like to get the hash and only elide the dirty check.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
