Return-Path: <linux-kernel-owner+w=401wt.eu-S1763313AbZEHXMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763313AbZEHXMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZEHXMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:12:13 -0400
Received: from mail.vyatta.com ([76.74.103.46]:44116 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZEHXMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:12:12 -0400
Date: Fri, 8 May 2009 16:12:04 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: jpirko@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH] net: introduce a list of device addresses dev_addr_list
 (v6)
Message-ID: <20090508161204.134668b9@nehalam>
In-Reply-To: <20090508.160008.127530143.davem@davemloft.net>
References: <20090505124827.GB3473@psychotron.englab.brq.redhat.com>
	<20090505.122718.51237316.davem@davemloft.net>
	<20090508153842.65ce3bed@s6510>
	<20090508.160008.127530143.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 May 2009 16:00:08 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Fri, 8 May 2009 15:38:42 -0700
> 
> > Not sure if this is such a good idea since the purpose of this was to fix
> > a bonding/bridging interaction, but it breaks STP on bridging.
> 
> Thanks for not paying attention... :-/
> 
> The Intel folks want to have an address list functionality so
> they can public MAC addresses meant for FCOE and other purposes.
> 
> So even if the bonding bits bomb, we still need this.

But the other infrastructure may have same issues (netfilter, etc).
Just seems like it would be either to have multiple network devices
so that upper layers could disambiguate easier.

-- 
