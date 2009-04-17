Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbZDQAP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbZDQAP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbZDQAPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:15:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:59669 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZDQAPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KfM6E2qBkuZP6Ic5rmRk/FmrI+bdUXYrvxhEKxgol9/+ZQ+tpDWftYptd1wmDhy4dZ
         SNOD270v1bfveNhc1bwIZg5nqutzkRSeNOyaR1V0dIzYK8XCBowyonSfRCdywLY3ce7g
         nNKVg9TQgSydIRJDL7I/1FzhXfVJ7FF/7uVxU=
MIME-Version: 1.0
In-Reply-To: <20090416165233.5d8bbfb5@nehalam>
References: <20090415170111.6e1ca264@nehalam>
	 <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>
	 <49E72E83.50702@trash.net>
	 <20090416.153354.170676392.davem@davemloft.net>
	 <20090416234955.GL6924@linux.vnet.ibm.com>
	 <20090416165233.5d8bbfb5@nehalam>
Date: Fri, 17 Apr 2009 08:15:44 +0800
Message-ID: <b6a2187b0904161715s46412569t4aa9b255427f9626@mail.gmail.com>
Subject: Re: [PATCH] netfilter: per-cpu spin-lock with recursion (v0.8)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
       kaber@trash.net, torvalds@linux-foundation.org, dada1@cosmosbay.com,
       paulus@samba.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 7:52 AM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> This version of x_tables (ip/ip6/arp) locking uses a per-cpu
> recursive lock that can be nested. It is sort of like existing kernel_lock,
> rwlock_t and even old 2.4 brlock.

Tested and working. As fast as before.

Thanks,
Jeff.
