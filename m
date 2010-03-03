Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0CCVPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:15:22 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:43652 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0CCVPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:15:16 -0500
From: James Cloos <cloos@jhcloos.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, geert@linux-m68k.org, elendil@planet.nl
Subject: Re: [PATCH] kconfig: place git SHA1 in .config output if in SCM
In-Reply-To: <20100303195804.GE6804@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Wed, 3 Mar 2010 11:58:04 -0800")
References: <20100303011858.GA17651@linux.vnet.ibm.com>
	<alpine.LFD.2.00.1003021725170.3616@localhost.localdomain>
	<20100303021624.GE6786@linux.vnet.ibm.com>
	<m37hptl3fl.fsf@lugabout.jhcloos.org>
	<20100303195804.GE6804@linux.vnet.ibm.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Wed, 03 Mar 2010 15:41:26 -0500
Message-ID: <m3eik1jfxt.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:30:100303:paulmck@linux.vnet.ibm.com::mv3qgjrX5wKkCQQt:00000000000000000000000000000000006T5M8
X-Hashcash: 1:30:100303:torvalds@linux-foundation.org::MXeMCRgOZIc8LkYI:0000000000000000000000000000000tCIE7
X-Hashcash: 1:30:100303:linux-kernel@vger.kernel.org::yekLqLT0Y/4l4VeT:00000000000000000000000000000000Fe7RW
X-Hashcash: 1:30:100303:zippel@linux-m68k.org::b5sr/iY/2Pysa3Bl:000000000000000000000000000000000000000N0GM+
X-Hashcash: 1:30:100303:mingo@elte.hu::MtZP30hontCHXb9O:0004z86p
X-Hashcash: 1:30:100303:akpm@linux-foundation.org::uUFDEXg9sV2mUWBa:00000000000000000000000000000000000gO69u
X-Hashcash: 1:30:100303:geert@linux-m68k.org::3dqXY/nUc9kv3+cA:00000000000000000000000000000000000000000PmGX
X-Hashcash: 1:30:100303:elendil@planet.nl::Wok/ct/s9yYuVrjO:00000000000000000000000000000000000000000005xAWw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Paul" == Paul E McKenney <paulmck@linux.vnet.ibm.com> writes:

JimC> Doesn't this patch simply duplicate CONFIG_LOCALVERSION_AUTO's
JimC> functionality, now that it calls scripts/setlocalversion?

JimC> I'd still like to get the hash and only elide the dirty check.

Paul> Would you be OK with having to set an environment variable to suppress
Paul> the dirty check?

Yes, most definitely OK.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
