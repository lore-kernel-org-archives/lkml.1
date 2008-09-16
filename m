Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYIPP7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYIPP7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYIPP7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:59:02 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:51363 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbYIPP7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:59:00 -0400
Message-ID: <48CFD7C3.5080207@opengridcomputing.com>
Date: Tue, 16 Sep 2008 10:58:59 -0500
From: Tom Tucker <tom@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
References: <48B2D7F8.5020206@opengridcomputing.com>	 <20080826192711.GJ4380@fieldses.org>	 <48B567F5.2090605@opengridcomputing.com>	 <1220111261.31172.14.camel@localhost.localdomain>	 <20080831193037.GB14876@fieldses.org>	 <1220211842.31172.18.camel@localhost.localdomain>	 <48BAF643.4070808@opengridcomputing.com>	 <1220217505.31172.26.camel@localhost.localdomain>	 <48BC2466.2070806@opengridcomputing.com>	 <1221036015.24993.27.camel@zakaz.uk.xensource.com>	 <20080912224323.GN22126@fieldses.org>	 <48CAF80A.4010109@opengridcomputing.com>	 <1221296243.2534.7.camel@localhost.localdomain>	 <1221544139.2534.18.camel@localhost.localdomain>	 <48CF9AC3.6060801@opengridcomputing.com> <1221577412.28572.60.camel@zakaz.uk.xensource.com>
In-Reply-To: <1221577412.28572.60.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Tue, 2008-09-16 at 06:38 -0500, Tom Tucker wrote:
>> Iain:
> 
> I'm actually Ian. (I don't actually mind that much, the other way round
> is probably much more annoying for people called Iain).
> 

Oops, sorry Ian.

>> I'm assuming you'll do this in advance of any patch from me?
> 
> I was going to grind through it unless/until you sent a patch.
> 
>> I was simply going to add printk to the various shutdown paths and see if we 
>> could get some finer grained debug output since the generic transport 
>> debug output was too verbose.
>>
>> Let me know and I'll help if I can,
> 
> You mean logging on the client or server side? I'm currently bisecting
> client. I'm happy to add some extra prints there if you point me in the
> direction of the code paths of interest.
> 

Ah. Ok. I'll send you a patch for the server.

> Ian.

