Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbZDVLjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbZDVLjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZDVLjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:39:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:1874 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZDVLjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=krnFTN3zaMqwYN9D9Jo4FYBZBJ1a9eNoFgVvxSQcoPKpqMIsgbLz2c+hTYH1TtjppF
         o/RzDB/TxIaZX+ydbmiLRCsrK+GBEU9W7uyUb54D/VQimR9P0W/wh5TYZtnQXwM30U86
         Usean4JpovHANOSpxG7rD4uk5xuL5WCSR86HU=
Date: Wed, 22 Apr 2009 11:39:02 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
Message-ID: <20090422113902.GB6630@ff.dom.local>
References: <49EEDAF0.2010507@cosmosbay.com> <20090422101318.GA6630@ff.dom.local> <20090422112612.GA3799@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422112612.GA3799@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 01:26:12PM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@gmail.com> wrote:
> 
> > On 22-04-2009 10:53, Eric Dumazet wrote:
> > ...
> > > If this could be done without recursion, I am pretty sure 
> > > netfilter and network guys would have done it. I found Linus 
> > > reaction quite shocking IMHO, considering hard work done by all 
> > > people on this.
> > 
> > Right, looks like 100% (Scandinavian?!) troll. I wonder where is 
> > the admin of this mess...
> 
> You might disagree with me on an honest technical basis, but note 
> that this kind of childish, knee-jerk reaction against dissenting 
> people is what gives netdev its bad reputation.

How did you find I disagree with you? There was nothing about you,
neither anything technical. Actually, I forgot to mention I agree with
Eric about your locking proposal.

Jarek P.
