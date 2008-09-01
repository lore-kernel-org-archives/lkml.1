Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbYIARUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbYIARUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYIARUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:20:41 -0400
Received: from mail.es335.com ([67.65.19.105]:21382 "EHLO mail.es335.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbYIARUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:20:40 -0400
Message-ID: <48BC2466.2070806@opengridcomputing.com>
Date: Mon, 01 Sep 2008 12:20:38 -0500
From: Tom Tucker <tom@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       John Ronciak <john.ronciak@gmail.com>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
References: <1219442213.9097.25.camel@localhost>	 <1219603981.27921.145.camel@localhost.localdomain>	 <1219605422.14389.2.camel@localhost> <1219605596.14389.5.camel@localhost>	 <1219615789.27921.152.camel@localhost.localdomain>	 <1219616136.14389.12.camel@localhost>	 <48B2D7F8.5020206@opengridcomputing.com>	 <20080826192711.GJ4380@fieldses.org>	 <48B567F5.2090605@opengridcomputing.com>	 <1220111261.31172.14.camel@localhost.localdomain>	 <20080831193037.GB14876@fieldses.org>	 <1220211842.31172.18.camel@localhost.localdomain>	 <48BAF643.4070808@opengridcomputing.com> <1220217505.31172.26.camel@localhost.localdomain>
In-Reply-To: <1220217505.31172.26.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Sun, 2008-08-31 at 14:51 -0500, Tom Tucker wrote:
>   
>> Looks like you ran this on the client. Sorry, Ian, I should have been
>> more specific. You need to modify the rpc_debug file on the server.
>>     
>
> I tried this on the server but it's pretty crippling (the server is
> quite weedy, 300MHz K3 or something).
>
> I'll leave it logging overnight since things should be pretty quiet (and
> that's often when the problem occurs) but if there's a less aggressive
> setting than 256 but which would still be useful I could leave it on
> permanently until the problem happens.
>
>   
Thanks Ian. Unfortunately, that's as fine grained as it gets. 256 
(0x100) is the bit for transport logging.
> Ian.
>   

