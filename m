Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab0AOQt7 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 11:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510Ab0AOQt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 11:49:58 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:50123 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab0AOQt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 11:49:58 -0500
Message-ID: <4B509C90.10305@freemail.hu>
Date: Fri, 15 Jan 2010 17:49:20 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Julia Lawall <julia@diku.dk>, Pekka Enberg <penberg@cs.helsinki.fi>,
        David Miller <davem@davemloft.net>, stefanr@s5r6.in-berlin.de,
        adi@hexapodia.org, david.vrabel@csr.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>
Subject: SmPL scripts into build environment? (was: Changelog quality)
References: <4B502C6B.7000802@s5r6.in-berlin.de> <20100115.005445.263291449.davem@davemloft.net> <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de> <20100115.012233.202457727.davem@davemloft.net> <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk> <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com> <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk> <20100115110845.GB28625@sirena.org.uk> <Pine.LNX.4.64.1001151303580.23543@ask.diku.dk> <20100115133933.GB21188@rakim.wolfsonmicro.main>
In-Reply-To: <20100115133933.GB21188@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02a.mail.t-online.hu 32711; Body=14
	Fuz1=14 Fuz2=14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

there was a discussion about patches which are generated using the
tool called spatch. In the changelog the SmPL script was usually
included, see http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git&a=search&h=HEAD&st=commit&s=%3Csmpl%3E .
It is useful to store the SmPL scripts because they may find
problems in the newcoming code also.

In order to run a "check" the spatch tool and the SmPL is also necessary.
There was an idea to place the used SmPL scripts under the Linux
kernel source tree so it can move from the changelog but still remain
for later use. The "check" could be run similar to the tools checkpatch,
sparse or lockdep.

What do you think where the SmPL scripts can be placed?

What do you think the best way would be to introduce some check like this
in the build environment?

Regards,

	Márton Németh
