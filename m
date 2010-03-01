Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0CAV2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:28:52 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:47084 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0CAV2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:28:50 -0500
From: James Cloos <cloos@jhcloos.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in git tree
In-Reply-To: <20100301164800.GC6758@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Mon, 1 Mar 2010 08:48:00 -0800")
References: <20100301042249.GA12289@linux.vnet.ibm.com>
	<alpine.LFD.2.00.1003010812410.3616@localhost.localdomain>
	<20100301164800.GC6758@linux.vnet.ibm.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Mon, 01 Mar 2010 15:46:26 -0500
Message-ID: <m3r5o34vnp.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Hashcash: 1:30:100301:paulmck@linux.vnet.ibm.com::Ac4a/aQ+T8l/+46B:0000000000000000000000000000000000kmVOr
X-Hashcash: 1:30:100301:torvalds@linux-foundation.org::83QX4d4vrbjmb49P:0000000000000000000000000000000TCl3v
X-Hashcash: 1:30:100301:linux-kernel@vger.kernel.org::u36xDjlIV4JIjwj6:00000000000000000000000000000000Zu/Zo
X-Hashcash: 1:30:100301:zippel@linux-m68k.org::OPmBgDQJcTbUfq0F:000000000000000000000000000000000000000p1jvR
X-Hashcash: 1:30:100301:mingo@elte.hu::bmdbPBkZUebNn7ns:000cJWhv
X-Hashcash: 1:30:100301:akpm@linux-foundation.org::mJvW9U9gc7Kcz8MA:00000000000000000000000000000000000CHzzX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Paul" == Paul E McKenney <paulmck@linux.vnet.ibm.com> writes:

Paul> Agreed!  The "-dirty" modifier for the case of changes not yet
Paul> checked into git looks especially helpful.

Except that the script calls »git update-index --refresh --unmerged«
and »git diff-index --name-only HEAD«, both of which are painfully
slow and resource intensive.

I'd hate to have that run every time I make a kernel.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
