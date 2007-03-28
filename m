Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbXC1VFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbXC1VFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXC1VFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:05:04 -0400
Received: from ms.trustica.cz ([82.208.32.68]:44845 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbXC1VFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:05:02 -0400
Message-ID: <460AD872.6020609@assembler.cz>
Date: Wed, 28 Mar 2007 23:04:50 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MSR: Add support for safe variants
References: <200703261157.l2QBvTJg011821@harpo.it.uu.se> <20070326140911.877430f5.khali@linux-fr.org>
In-Reply-To: <20070326140911.877430f5.khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mikael,

> Maybe I'm in the minority here, but I for one strongly believe
> that any attempt to access an MSR "which might not be there" is
> inherently wrong. It implies that your HW detection is incomplete,
> which in combination with MSR accesses means that you may end up
> accessing MSRs that aren't at all what you think they should be.

Well I have some info from Intel, but the register is simply not always there. 
So instead of oopsing kernel, handling the exception is much better.

For further details please check:
http://softwarecommunity.intel.com/isn/Community/en-US/forums/thread/30229027.aspx

(last page) I may have more info in the future.

> Who supplies these imprecise MSR definitions anyway?

Yes Intel, please check the thread. Sometimes similar to catch 22 ;)

Rudolf
