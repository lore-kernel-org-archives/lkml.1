Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZD3D04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZD3D04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 23:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZD3D0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 23:26:43 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:29008 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZD3D0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 23:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cHLrLUfChNXr0UidoC3s6ibSW59QnI/iNgNbGQ8RA5M+Iro6jlG2zM20pycXXL+kTQ
         2WivyfBmpjmmxZGIFJVudI5bMk2vL/3+Hj/JrzWshzr0oNwMMcgVoJRu3F+nIu/b/ICI
         /4e1AtgcAWRXgJAbKeY4feWKs35YeBaF1MVGg=
MIME-Version: 1.0
In-Reply-To: <20090428.223708.168741998.davem@davemloft.net>
References: <20090428092411.5331c4a1@nehalam>
	 <alpine.LFD.2.00.0904280931360.22156@localhost.localdomain>
	 <alpine.LFD.2.00.0904280954500.22156@localhost.localdomain>
	 <20090428.223708.168741998.davem@davemloft.net>
Date: Thu, 30 Apr 2009 11:26:40 +0800
Message-ID: <b6a2187b0904292026k7d6107a7vcdc761d4149f40aa@mail.gmail.com>
Subject: Re: [PATCH] netfilter: revised locking for x_tables
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       dada1@cosmosbay.com, zbr@ioremap.net, peterz@infradead.org,
       jarkao2@gmail.com, paulus@samba.org, paulmck@linux.vnet.ibm.com,
       kaber@trash.net, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 1:37 PM, David Miller <davem@davemloft.net> wrote:
> I've applied this, thanks everyone!

I see the patch is already in Linus's tree that I just git pulled.
Tested for 200 iptables rules ... as fast as before the slow down.

real    0m0.211s
user    0m0.060s
sys     0m0.144s

Thank you all for fixing this bug!


On Sun, Apr 26, 2009 at 3:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13118
> Subject         : iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-04-10 16:05 (16 days old)
> References      : http://lkml.org/lkml/2009/4/10/111
> Handled-By      : Eric Dumazet <dada1@cosmosbay.com>

Rafael, it's fixed. Please close the case.


Thanks,
Jeff.
